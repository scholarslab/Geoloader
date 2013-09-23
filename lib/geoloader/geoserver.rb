
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
    end

    # Create a new coverage store and publish a layer from a GeoTIFF.
    #
    # @param [Geoloader::Geotiff] tiff
    # @return [RestClient::Response]
    def upload_geotiff tiff

      # Construct the URL.
      url = "#{@config[:url]}/workspaces/#{@config[:workspace]}"
      url += "/coveragestores/#{tiff.base}/file.geotiff"

      # Create the store.
      RestClient::Request.new(
        :method   => :put,
        :payload  => File.read(tiff.path),
        :user     => @config[:username],
        :password => @config[:password],
        :url      => url
      ).execute

    end

  end
end
