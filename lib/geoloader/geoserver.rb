
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'rest_client'

module Geoloader
  class Geoserver

    # @param [OrderedHash] config
    # @param [String] config :url
    # @param [String] config :username
    # @param [String] config :password
    # @param [String] config :workspace
    def initialize config = {}
      @config = config
    end

    # @param [Geoloader::Geotiff] tiff
    def upload_geotiff tiff
      RestClient::Request.new(
        :method   => :put,
        :user     => config[:username],
        :password => config[:password],
        :body     => File.read(tiff.path),
        :url      => config[:url]
      ).execute
    end

  end
end
