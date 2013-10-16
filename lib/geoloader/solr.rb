
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'rsolr'

module Geoloader
  class Solr

    attr_reader :resource

    def initialize

      # Alias the Solr config.
      @config = Geoloader.config.solr

      # Create the REST resource.
      @resource = RSolr.connect(:url => @config.url)

    end

    # Add a new document to the index.
    #
    # @param [Geoloader::Asset] geotiff
    def create_document(asset)
      # TODO
    end

  end
end
