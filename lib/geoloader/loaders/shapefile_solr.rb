
module Geoloader
  module Loaders

    class ShapefileSolr < Loader

      attr_reader :shapefile, :solr

      @queue = :geoloader

      #
      # Configure the shapefile, connect to Solr.
      #
      def initialize(*args)

        super

        # Create and configure the asset.
        @shapefile = Geoloader::Assets::Asset.new(@file_path, @workspace, @desc_path)
        @shapefile.extend(Geoloader::Assets::Shapefile)
        @shapefile.extend(Geoloader::Assets::Solr)

        # Connect to Solr.
        @solr = Geoloader::Services::Solr.new

      end

      #
      # Push a Shapefile to Solr.
      #
      def load
        @shapefile.stage do
          @solr.create_document(@shapefile)
        end
      end

    end

  end
end
