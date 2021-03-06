
module Geoloader
  module Loaders

    class ShapefileGeoserver < Loader

      attr_reader :shapefile, :geoserver

      @queue = :geoloader

      #
      # Configure the asset, connect to Geoserver.
      #
      def initialize(*args)

        super

        # Create and configure the asset.
        @shapefile = Geoloader::Assets::Asset.new(@file_path, @workspace, @desc_path)
        @shapefile.extend(Geoloader::Assets::Shapefile)

        # Connect to Geoserver, create the workspace.
        @geoserver = Geoloader::Services::Geoserver.new
        @geoserver.ensure_workspace(@workspace)

      end

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
