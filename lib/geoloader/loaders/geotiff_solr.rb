
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require_relative 'abstract/base'
require_relative 'abstract/geotiff'
require_relative 'abstract/solr'

module Geoloader
  module Loaders
    class GeotiffSolr < Abstract::Loader

      include Abstract::Geotiff
      include Abstract::Solr

      @queue = :geoloader

      #
      # Push a GeoTIFF to Solr.
      #
      def load
        @geotiff.stage do
          @solr.create_document(@geotiff)
        end
      end

    end
  end
end
