
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'rsolr'
require 'securerandom'

module Geoloader
  class Solr

    attr_reader :resource

    def initialize
      @config = Geoloader.config.solr
      @resource = RSolr.connect(:url => @config.url)
    end

    # TODO|dev
    # Add a new document to the index.
    #
    # @param [Geoloader::Asset] asset
    def create_document(asset)
      @resource.add({
        :id     => asset.uuid,
        :layer  => asset.slug
      })
      @resource.commit
    end

    # Delete all documents.
    def clear_index
      @resource.delete_by_query("*:*")
      @resource.commit
    end

  end
end
