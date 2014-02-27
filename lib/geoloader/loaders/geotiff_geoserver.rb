
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require_relative 'abstract/base'
require_relative 'abstract/geoserver'
require_relative 'abstract/geotiff'

module Geoloader
  module Loaders
    class GeotiffGeoserver < Abstract::Base

      include Abstract::Geotiff
      include Abstract::Geoserver

      @queue = :geoloader

      #
      # Push a GeoTIFF to Geoserver.
      #
      def load
        @geotiff.stage do

          # Prepare the file.
          @geotiff.make_borders_transparent
          @geotiff.project_to_4326

          # Push to Geoserver.
          @geoserver.create_coveragestore(@geotiff)

        end
      end

    end
  end
end
