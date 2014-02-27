
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require_relative 'abstract/base'
require_relative 'abstract/asset'
require_relative 'abstract/geonetwork'

module Geoloader
  module Loaders
    class Geonetwork < Base

      include Base::Asset
      include Base::Geonetwork

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
end
