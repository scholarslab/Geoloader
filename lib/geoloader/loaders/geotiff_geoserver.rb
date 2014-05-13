
module Geoloader
  module Loaders

    class GeotiffGeoserver < Loader

      attr_reader :geotiff, :geoserver

      @queue = :geoloader

      #
      # Configure the asset, connect to Geoserver.
      #
      def initialize(*args)

        super

        # Create and configure the asset.
        @geotiff = Geoloader::Assets::Asset.new(@file_path, @workspace, @desc_path)
        @geotiff.extend(Geoloader::Assets::Geotiff)

        # Connect to Geoserver, create the workspace.
        @geoserver = Geoloader::Services::Geoserver.new
        @geoserver.ensure_workspace(@workspace)

      end

      #
      # Push a GeoTIFF to Geoserver.
      #
      def load
        @geotiff.stage do

          # Prepare the file.
          @geotiff.make_borders_transparent
          @geotiff.reproject

          # Push to Geoserver.
          @geoserver.create_coveragestore(@geotiff)

        end
      end

    end

  end
end
