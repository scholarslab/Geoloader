
module Geoloader
  module Tasks

    module Geoserver

      #
      # Delete all stores from a Geoserver workspace.
      #
      # @param [String] workspace
      #
      def self.clear(workspace)
        Geoloader::Services::Geoserver.new.delete_workspace(workspace)
      end

    end

  end
end
