
module Geoloader
  module Loaders

    class GeotiffSolr < Loader

      attr_reader :geotiff, :solr

      @queue = :geoloader

      #
      # Configure the asset, connect to Solr.
      #
      def initialize(*args)

        super

        # Create and configure the asset.
        @geotiff = Geoloader::Assets::Asset.new(@file_path, @workspace, @desc_path)
        @geotiff.extend(Geoloader::Assets::Geotiff)
        @geotiff.extend(Geoloader::Assets::Solr)

        # Connect to Solr.
        @solr = Geoloader::Services::Solr.new

      end

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
