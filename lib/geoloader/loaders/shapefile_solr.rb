
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require_relative 'abstract/base'
require_relative 'abstract/shapefile'
require_relative 'abstract/solr'

module Geoloader
  module Loaders
    class ShapefileSolr < Abstract::Loader

      include Abstract::Shapefile
      include Abstract::Solr

      @queue = :geoloader

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
