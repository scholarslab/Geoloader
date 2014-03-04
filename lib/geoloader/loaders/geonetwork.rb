
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  module Loaders

    class Geonetwork < Loader

      attr_reader :asset, :geonetwork

      @queue = :geoloader

      #
      # Configure the asset, connect to Geonetwork.
      #
      def initialize(*args)

        super

        # Create and configure the asset.
        @asset = Geoloader::Assets::Asset.new(@file_path, @workspace)
        @asset.extend(Geoloader::Assets::Geonetwork)

        # Connect to Geonetwork, create the group.
        @geonetwork = Geoloader::Services::Geonetwork.new
        @geonetwork.ensure_group(@workspace)

      end

      #
      # Push an asset to Geonetwork.
      #
      def load
        @asset.stage do
          @geonetwork.create_record(@asset)
        end
      end

    end

  end
end
