
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'rest_client'

module Geoloader
  class Geoserver

    # Create a new coverage store and publish a layer from a GeoTIFF.
    #
    # @param [Geoloader::Geotiff] tiff
    # @return [RestClient::Response]
    def upload_geotiff tiff

      # Construct the URL.
      url = "#{Geoloader::config.geoserver.url}/workspaces/#{Geoloader::config.geoserver.workspace}"
      url += "/coveragestores/#{tiff.base}/file.geotiff"

      # Create the store.
      RestClient::Request.new(
        :method   => :put,
        :payload  => File.read(tiff.path),
        :user     => Geoloader::config.geoserver.username,
        :password => Geoloader::config.geoserver.password,
        :url      => url
      ).execute

    end

  end
end
