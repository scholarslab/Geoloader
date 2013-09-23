
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'rest_client'

module Geoloader
  class Geoserver

    # Create Geoserver resource.
    def initialize
      @config = Geoloader.config.geoserver
      @resource = RestClient::Resource.new @config.url, {
        :user     => @config.username,
        :password => @config.password
      }
    end

    # Create a new coverage store from a GeoTIFF.
    #
    # @param [Geoloader::Geotiff] tiff
    # @return [RestClient::Response]
    def upload_geotiff tiff
      service = "workspaces/#{@config.workspace}/coveragestores/#{tiff.base}/file.geotiff"
      @resource[service].put File.read(tiff.path)
    end

  end
end
