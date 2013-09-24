
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
      geotiff.process unless geotiff.processed
      url = "workspaces/#{@config.workspace}/coveragestores/#{geotiff.base_name}/file.geotiff"
      @resource[url].put File.read(geotiff.processed_path)
    end

    # Publish the PostGIS table corresponding to a shapefile.
    #
    # @param [Geoloader::Shapefile] shapefile
    # @return [RestClient::Response]
    def publish_table shapefile
      payload = Builder::XmlMarkup.new.featureType { |f| f.name shapefile.base_name }
      url = "workspaces/#{@config.workspace}/datastores/#{@config.datastore}/featuretypes"
      @resource[url].post payload, :content_type => :xml
    end

  end
end
