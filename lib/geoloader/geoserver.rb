
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'rest_client'

module Geoloader
  class Geoserver

    # Set connection parameters.
    #
    # @param [OrderedHash] config
    # @param [String] config :url
    # @param [String] config :username
    # @param [String] config :password
    # @param [String] config :workspace
    def initialize config = {}
      @config = config
      @resource = RestClient::Resource.new @config[:url], {
        :user     => @config[:username],
        :password => @config[:password]
      }
    end

    # Create a new coverage store and publish a layer from a GeoTIFF.
    #
    # @param [Geoloader::Geotiff] tiff
    # @return [RestClient::Response]
    def upload_geotiff tiff
      service = "workspaces/#{@config[:workspace]}/coveragestores/#{tiff.base}/file.geotiff"
      @resource[service].put File.read(tiff.path)
    end

  end
end
