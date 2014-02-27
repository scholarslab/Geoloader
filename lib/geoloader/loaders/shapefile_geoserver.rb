
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'abstract/base'

module Geoloader
  module Loaders
    class ShapefileGeoserver < Loader

      include Loader::Shapefile
      include Loader::Geoserver

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
