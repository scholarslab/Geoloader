
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class Geoserver

    # @param [OrderedHash] options
    # @option options [String] :url
    # @option options [String] :username
    # @option options [String] :password
    def initialize options = {}
      @config = options
    end

    def upload_geotiff
      # TODO
    end

    def upload_shapefile
      # TODO
    end

  end
end
