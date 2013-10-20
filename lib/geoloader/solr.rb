
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'rsolr-ext'

module Geoloader
  class Solr

    attr_reader :resource

    #
    # Initialize the API wrapper.
    #
    def initialize
      @resource = RSolr::Ext.connect(:url => Geoloader.config.solr.url)
    end

    #
    # Add a new document to the index.
    #
    # @param [Geoloader::Asset] asset
    # @param [Hash] manifest
    #
    def create_document(asset, manifest)
      @resource.add({
        :id           => asset.uuid,
        :title        => manifest.title,
        :description  => manifest.description,
        :workspace    => manifest.workspace,
        :layer        => asset.base_name
      })
      @resource.commit
    end

    #
    # Delete all documents in a given workspace.
    #
    # @param [String] workspace
    #
    def delete_by_workspace(workspace)
      @resource.delete_by_query("workspace:#{workspace}")
      @resource.commit
    end

  end
end
