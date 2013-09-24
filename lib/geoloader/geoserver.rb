
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'rest_client'

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
    # @param [Geoloader::Geotiff] tiff
    # @return [RestClient::Response]
    def add_geotiff tiff
      url = "workspaces/#{@config.workspace}/coveragestores/#{tiff.base_name}/file.geotiff"
      @resource[url].put File.read(tiff.processed_path)
    end

  end
end
