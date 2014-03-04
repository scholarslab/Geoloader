
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "rsolr-ext"

module Geoloader
  module Services

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
      #
      def create_document(asset)
        @resource.add(asset.solr_document)
        @resource.commit
      end

      #
      # Count the number of documents in each workspace.
      #
      def get_workspace_counts

        workspaces = []

        # Select all documents, 0 rows, faceting on workspace.
        query = { :queries => "*:*", :facets => { :fields => "WorkspaceName" }, :rows => 0 }

        # Flatted out the counts.
        @resource.find(query).facets.each do |facet|
          facet.items.each do |item|
            workspaces << [item.value, item.hits]
          end
        end

        workspaces

      end

      #
      # Delete all documents in a workspace.
      #
      # @param [String] workspace
      #
      def delete_by_workspace(workspace)
        @resource.delete_by_query("WorkspaceName:#{workspace}")
        @resource.commit
      end

    end

  end
end
