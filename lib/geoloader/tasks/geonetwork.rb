
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  module Tasks

    module Geonetwork

      #
      # Publish all records in a Geonetwork group.
      #
      # @param [String] workspace
      #
      def self.publish(workspace)
        Geoloader::Services::Geonetwork.new.publish_group(workspace)
      end

      #
      # Delete all stores from a Geonetwork group.
      #
      # @param [String] workspace
      #
      def self.clear(workspace)
        Geoloader::Services::Geonetwork.new.delete_records_by_group(workspace)
      end

    end

  end
end
