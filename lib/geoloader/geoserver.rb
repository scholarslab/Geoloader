
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'rest_client'
require 'builder'

module Geoloader
  class Geoserver

    # Create the Geoserver resource.
    def initialize
      @config = Geoloader.config.geoserver
      @resource = RestClient::Resource.new @config.url, {
        :user     => @config.username,
        :password => @config.password
      }
    end

    # Create a new coverage store and layer.
    #
    # @param [Geoloader::Geotiff] geotiff
    # @return [RestClient::Response]
    def upload_geotiff geotiff
      url = "workspaces/#{@config.workspace}/coveragestores/#{geotiff.base_name}/file.geotiff"
      @resource[url].put File.read(geotiff.processed_path)
    end

    # Publish the PostGIS database corresponding to a shapefile.
    #
    # @param [Geoloader::Shapefile] shapefile
    # @return [RestClient::Response]
    def publish_database shapefile

      # Construct the datastore XML.
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

      # Create the new data store.
      url = "workspaces/#{@config.workspace}/datastores"
      @resource[url].post payload, :content_type => :xml

    end

    # Publish layers from the PostGIS tables corresponding to a shapefile.
    #
    # @param [Geoloader::Shapefile] shapefile
    # @return [RestClient::Response]
    def publish_tables shapefile
      url = "workspaces/#{@config.workspace}/datastores/#{geotiff.base_name}/featuretypes"
      @resource[url].put File.read(shapefile.file_path)
    end

  end
end
