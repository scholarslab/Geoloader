
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'rest_client'
require 'builder'
require 'nokogiri'

module Geoloader
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
    # @param [String] name
    #
    def create_workspace(workspace)
      payload = Builder::XmlMarkup.new.workspace { |w| w.name workspace }
      @resource["workspaces"].post(payload, :content_type => :xml)
    end

    #
    # Check to see if a workspace exists, and if not, create it.
    #
    # @param [String] name
    #
    def ensure_workspace(workspace)
      create_workspace(workspace) unless workspace_exists?(workspace)
    end

    #
    # Delete a workspace.
    #
    # @param [String] name
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
      url = "workspaces/#{geotiff.workspace}/coveragestores/#{geotiff.base_name}/file.geotiff"
      @resource[url].put(File.read(geotiff.file_path))
    end

    #
    # Delete the coveragestore that corresponds to a GeoTIFF.
    #
    # @param [Geoloader::Geotiff] geotiff
    #
    def delete_coveragestore(geotiff)
      url = "workspaces/#{geotiff.workspace}/coveragestores/#{geotiff.base_name}"
      @resource[url].delete({:params => {:recurse => true}})
    end

    #
    # Publish the PostGIS database corresponding to a shapefile.
    #
    # @param [Geoloader::Shapefile] shapefile
    #
    def create_datastore(shapefile)

      # Construct the request.
      payload = Builder::XmlMarkup.new.dataStore { |d|
        d.name shapefile.base_name
        d.connectionParameters { |c|
          c.host      Geoloader.config.postgis.host
          c.port      Geoloader.config.postgis.port
          c.user      Geoloader.config.postgis.username
          c.passwd    Geoloader.config.postgis.password
          c.database  shapefile.slug
          c.dbtype    "postgis"
        }
      }

      # Create the new datastore.
      url = "workspaces/#{shapefile.workspace}/datastores"
      @resource[url].post(payload, :content_type => :xml)

    end

    #
    # Delete the datastore that corresponds to a shapefile.
    #
    # @param [Geoloader::Shapefile] shapefile
    #
    def delete_datastore(shapefile)
      url = "workspaces/#{shapefile.workspace}/datastores/#{shapefile.base_name}"
      @resource[url].delete({:params => {:recurse => true}})
    end

    #
    # Publish layers from the PostGIS tables corresponding to a shapefile.
    #
    # @param [Geoloader::Shapefile] shapefile
    #
    def create_featuretypes(shapefile)

      shapefile.get_layers.each { |layer|

        # Construct the request.
        payload = Builder::XmlMarkup.new.featureType { |f|
          f.name layer
          f.srs Geoloader.config.geoserver.srs
        }

        # Create the new featuretype.
        url = "workspaces/#{shapefile.workspace}/datastores/#{shapefile.base_name}/featuretypes"
        @resource[url].post(payload, :content_type => :xml)

      }

    end

  end
end
