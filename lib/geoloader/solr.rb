
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'rsolr'
require 'securerandom'

module Geoloader
  class Solr

    attr_reader :resource

    #
    # Initialize the API wrapper.
    #
    def initialize
      @resource = RSolr.connect(:url => Geoloader.config.solr.url)
    end

    #
    # Add a new document to the index.
    #
    # @param [Geoloader::Asset] asset
    # @param [Hash] metadata
    #
    def create_document(asset, metadata)
      @resource.add({
        :id           => asset.uuid,
        :title        => metadata["title"],
        :description  => metadata["description"],
        :workspace    => metadata["workspace"],
        :layer        => asset.base_name
      })
      @resource.commit
    end

    #
    # Query for an individual asset document.
    #
    # @param [Geoloader::Asset] asset
    #
    def get_document(asset)
      @resource.get("select", :params => {:q => "id:#{asset.uuid}"})
    end

    #
    # Does a document exist for a given asset?.
    #
    # @param [Geoloader::Asset] asset
    #
    def document_exists?(asset)
      get_document(asset)["response"]["numFound"].to_i == 1
    end

    #
    # Delete the document for a given asset.
    #
    # @param [Geoloader::Asset] asset
    #
    def delete_document(asset)
      @resource.delete_by_query("id:#{asset.uuid}")
      @resource.commit
    end

    #
    # Delete all documents.
    #
    def clear_index
      @resource.delete_by_query("*:*")
      @resource.commit
    end

  end
end
