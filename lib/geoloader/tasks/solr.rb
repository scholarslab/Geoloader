
module Geoloader
  module Tasks

    module Solr

      #
      # Delete all Solr documents in a workspace.
      #
      # @param [String] workspace
      #
      def self.clear(workspace)
        Geoloader::Services::Solr.new.delete_by_workspace(workspace)
      end

    end

  end
end
