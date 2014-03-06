
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  module CLI

    module Tasks

      #
      # Delete all stores from a Geoserver workspace.
      #
      # @param [String] workspace
      #
      def clear_geoserver(workspace)
        Geoloader::Services::Geoserver.new.delete_workspace(workspace)
      end

      #
      # Delete all stores from a Geonetwork group.
      #
      # @param [String] workspace
      #
      def clear_geonetwork(workspace)
        Geoloader::Services::Geonetwork.new.delete_records_by_group(workspace)
      end

      #
      # Delete all Solr documents in a workspace.
      #
      # @param [String] workspace
      #
      def clear_solr(workspace)
        Geoloader::Services::Solr.new.delete_by_workspace(workspace)
      end

    end

  end
end
