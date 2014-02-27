
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'abstract/base'

module Geoloader
  module Loaders
    class GeotiffSolr < Loader

      include Loader::Geotiff
      include Loader::Solr

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
