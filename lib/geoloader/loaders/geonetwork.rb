
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require_relative 'abstract/base'
require_relative 'abstract/geonetwork'
require_relative 'abstract/asset'

module Geoloader
  module Loaders
    class Geonetwork < Abstract::Loader

      include Abstract::Asset
      include Abstract::Geonetwork

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
