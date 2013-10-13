
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'rest_client'
require 'builder'

module Geoloader
  class Geoserver

    attr_reader :resource

    # Create the Geoserver resource.
    def initialize

      # Alias config, create resource.
      @config = Geoloader.config.geoserver
      @resource = RestClient::Resource.new("#{@config.url}/rest", {
        :user     => @config.username,
        :password => @config.password
      })

      # If necessary, create the workspace.
      if not workspace_exists?(@config.workspace)
        create_workspace(@config.workspace)
      end

    end

    # Does a workspace with a given name exist?
    #
    # @param  [String] name
    # @return [Boolean]
    def workspace_exists?(name)
      !!Nokogiri::XML(@resource["workspaces"].get).at_xpath("//workspace[name[text()='#{name}']]")
    end

    # Create a new workspace.
    #
    # @param  [String] name
    # @return [RestClient::Response]
    def create_workspace(name)
      payload = Builder::XmlMarkup.new.workspace { |w| w.name name }
      @resource["workspaces"].post(payload, :content_type => :xml)
    end

    # Delete a workspace.
    #
    # @param  [String] name
    # @return [RestClient::Response]
    def delete_workspace(name)
      @resource["workspaces/#{name}"].delete({:params => {:recurse => true}})
    end

    # Create a new coveragestore and layer for a GeoTIFF.
    #
    # @param  [Geoloader::Geotiff] geotiff
    # @return [RestClient::Response]
    def create_coveragestore(geotiff)
      url = "workspaces/#{@config.workspace}/coveragestores/#{geotiff.base_name}/file.geotiff"
      @resource[url].put(File.read(geotiff.processed_path))
    end

    # Delete the coveragestore that corresponds to a GeoTIFF.
    #
    # @param  [Geoloader::Geotiff] geotiff
    # @return [RestClient::Response]
    def delete_coveragestore(geotiff)
      url = "workspaces/#{@config.workspace}/coveragestores/#{geotiff.base_name}"
      @resource[url].delete({:params => {:recurse => true}})
    end

    # Publish the PostGIS database corresponding to a shapefile.
    #
    # @param  [Geoloader::Shapefile] shapefile
    # @return [RestClient::Response]
    def create_datastore(shapefile)

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
      url = "workspaces/#{@config.workspace}/datastores"
      @resource[url].post(payload, :content_type => :xml)

    end

    # Delete the datastore that corresponds to a shapefile.
    #
    # @param  [Geoloader::Shapefile] shapefile
    # @return [RestClient::Response]
    def delete_datastore(shapefile)
      url = "workspaces/#{@config.workspace}/datastores/#{shapefile.base_name}"
      @resource[url].delete({:params => {:recurse => true}})
    end

    # Publish layers from the PostGIS tables corresponding to a shapefile.
    #
    # @param  [Geoloader::Shapefile] shapefile
    # @return [RestClient::Response]
    def create_featuretypes(shapefile)
      shapefile.get_layers.each { |layer|

        payload = Builder::XmlMarkup.new.featureType { |f|
          f.name layer
          f.srs @config.srs
        }

        # Create the new featuretype.
        url = "workspaces/#{@config.workspace}/datastores/#{shapefile.base_name}/featuretypes"
        @resource[url].post(payload, :content_type => :xml)

      }
    end

  end
end
