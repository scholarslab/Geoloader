
require "rest_client"
require "builder"
require "nokogiri"

module Geoloader
  module Services

    class Geoserver

      attr_reader :resource

      #
      # Initialize the API wrapper.
      #
      def initialize
        @resource = RestClient::Resource.new("#{Geoloader.config.geoserver.url}/rest", {
          :user     => Geoloader.config.geoserver.username,
          :password => Geoloader.config.geoserver.password
        })
      end

      #
      # Does a workspace with a given name exist?
      #
      # @param [String] workspace
      #
      def workspace_exists?(workspace)
        workspaces = @resource["workspaces"].get
        !!Nokogiri::XML(workspaces).at_xpath("//workspace[name[text()='#{workspace}']]")
      end

      #
      # Create a new workspace.
      #
      # @param [String] workspace
      #
      def create_workspace(workspace)
        payload = Builder::XmlMarkup.new.workspace { |w| w.name workspace }
        @resource["workspaces"].post(payload, :content_type => :xml)
      end

      #
      # Check to see if a workspace exists, and if not, create it.
      #
      # @param [String] workspace
      #
      def ensure_workspace(workspace)
        create_workspace(workspace) unless workspace_exists?(workspace)
      end

      #
      # Delete a workspace.
      #
      # @param [String] workspace
      #
      def delete_workspace(workspace)
        @resource["workspaces/#{workspace}"].delete({:params => {:recurse => true}})
      end

      #
      # Create a new coveragestore and layer for a GeoTIFF.
      #
      # @param [Geoloader::Geotiff] geotiff
      #
      def create_coveragestore(geotiff)
        url = "workspaces/#{geotiff.workspace}/coveragestores/#{geotiff.file_base}/file.geotiff"
        @resource[url].put(File.read(geotiff.file_name))
      end

      #
      # Delete the coveragestore that corresponds to a GeoTIFF.
      #
      # @param [Geoloader::Geotiff] geotiff
      #
      def delete_coveragestore(geotiff)
        url = "workspaces/#{geotiff.workspace}/coveragestores/#{geotiff.file_base}"
        @resource[url].delete({:params => {:recurse => true}})
      end

      #
      # Create a new datastore and layer for a Shapefile.
      #
      # @param [Geoloader::Shapefile] shapefile
      #
      def create_datastore(shapefile)
        url = "workspaces/#{shapefile.workspace}/datastores/#{shapefile.file_base}/file.shp"
        @resource[url].put(shapefile.get_zipfile, :content_type => :zip)
      end

      #
      # Delete the datastore that corresponds to a shapefile.
      #
      # @param [Geoloader::Shapefile] shapefile
      #
      def delete_datastore(shapefile)
        url = "workspaces/#{shapefile.workspace}/datastores/#{shapefile.file_base}"
        @resource[url].delete({:params => {:recurse => true}})
      end

    end

  end
end
