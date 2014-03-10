
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  module Tasks

    module Geonetwork

      #
      # Delete all stores from a Geonetwork group.
      #
      # @param [String] workspace
      #
      def clear(workspace)
        Geoloader::Services::Geonetwork.new.delete_records_by_group(workspace)
      end

    end

  end
end
