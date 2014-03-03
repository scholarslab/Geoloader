
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require_relative 'abstract/base'
require_relative 'abstract/shapefile'
require_relative 'abstract/geoserver'

module Geoloader
  module Loaders
    class ShapefileGeoserver < Abstract::Loader

      include Abstract::Shapefile
      include Abstract::Geoserver

      @queue = :geoloader

      #
      # Push a Shapefile to Geoserver.
      #
      def load
        @shapefile.stage do
          @geoserver.create_datastore(@shapefile)
        end
      end

    end
  end
end
