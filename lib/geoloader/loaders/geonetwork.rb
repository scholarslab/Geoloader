
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class GeonetworkLoader < Loader

    include Loader::Asset
    include Loader::Geonetwork

    @queue = :geoloader

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
