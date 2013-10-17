
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'rest_client'
require 'builder'

module Geoloader
  class Geoserver

    attr_reader :resource

    #
    # Initialize the service wrapper and create the workspace.
    #
    # @param [String] workspace
    #
    def initialize(workspace)

      # Alias the configuration.
      @config = Geoloader.config.geoserver
      @workspace = workspace

      # Create the REST resource.
      @resource = RestClient::Resource.new("#{@config.url}/rest", {
        :user     => @config.username,
        :password => @config.password
      })

      # Create the workspace.
      create_workspace unless workspace_exists?

    end

    #
    # Does a workspace with a given name exist?
    #
    # @param [String] workspace
    #
    def workspace_exists?(workspace = @workspace)
      workspaces = @resource["workspaces"].get
      !!Nokogiri::XML(workspaces).at_xpath("//workspace[name[text()='#{workspace}']]")
    end

    #
    # Create a new workspace.
    #
    # @param [String] name
    #
    def create_workspace(workspace = @workspace)
      payload = Builder::XmlMarkup.new.workspace { |w| w.name workspace }
      @resource["workspaces"].post(payload, :content_type => :xml)
    end

    #
    # Delete a workspace.
    #
    # @param [String] name
    #
    def delete_workspace(workspace = @workspace)
      @resource["workspaces/#{workspace}"].delete({:params => {:recurse => true}})
    end

    #
    # Create a new coveragestore and layer for a GeoTIFF.
    #
    # @param [Geoloader::Geotiff] geotiff
    # @param [String] workspace
    #
    def create_coveragestore(geotiff, workspace = @workspace)
      url = "workspaces/#{workspace}/coveragestores/#{geotiff.base_name}/file.geotiff"
      @resource[url].put(File.read(geotiff.file_path))
    end

    #
    # Delete the coveragestore that corresponds to a GeoTIFF.
    #
    # @param [Geoloader::Geotiff] geotiff
    # @param [String] workspace
    #
    def delete_coveragestore(geotiff, workspace = @workspace)
      url = "workspaces/#{workspace}/coveragestores/#{geotiff.base_name}"
      @resource[url].delete({:params => {:recurse => true}})
    end

    #
    # Publish the PostGIS database corresponding to a shapefile.
    #
    # @param [Geoloader::Shapefile] shapefile
    # @param [String] workspace
    #
    def create_datastore(shapefile, workspace = @workspace)

      # Construct the request.
      payload = Builder::XmlMarkup.new.dataStore { |d|
        d.name shapefile.base_name
        d.connectionParameters { |c|
          c.host      Geoloader.config.postgis.host
          c.port      Geoloader.config.postgis.port
          c.user      Geoloader.config.postgis.username
          c.passwd    Geoloader.config.postgis.password
          c.database  shapefile.base_name
          c.dbtype    "postgis"
        }
      }

      # Create the new datastore.
      url = "workspaces/#{workspace}/datastores"
      @resource[url].post(payload, :content_type => :xml)

    end

    #
    # Delete the datastore that corresponds to a shapefile.
    #
    # @param [Geoloader::Shapefile] shapefile
    # @param [String] workspace
    #
    def delete_datastore(shapefile, workspace = @workspace)
      url = "workspaces/#{workspace}/datastores/#{shapefile.base_name}"
      @resource[url].delete({:params => {:recurse => true}})
    end

    #
    # Publish layers from the PostGIS tables corresponding to a shapefile.
    #
    # @param [Geoloader::Shapefile] shapefile
    # @param [String] workspace
    #
    def create_featuretypes(shapefile, workspace = @workspace)

      shapefile.get_layers.each { |layer|

        # Construct the request.
        payload = Builder::XmlMarkup.new.featureType { |f|
          f.name layer
          f.srs @config.srs
        }

        # Create the new featuretype.
        url = "workspaces/#{workspace}/datastores/#{shapefile.base_name}/featuretypes"
        @resource[url].post(payload, :content_type => :xml)

      }

    end

  end
end
