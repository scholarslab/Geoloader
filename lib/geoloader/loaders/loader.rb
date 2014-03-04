
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  module Loaders

    class Loader

      #
      # Perform an upload (used by Resque).
      #
      # @param [String] file_name
      # @param [String] workspace
      #
      def self.perform(file_path, workspace)
        new(file_path, workspace).load
        puts "Loaded #{File.basename(file_path)}."
      end

      #
      # Set the file path and workspace.
      #
      # @param [String] file_name
      # @param [String] workspace
      #
      def initialize(file_path, workspace)
        @file_path = file_path
        @workspace = workspace
      end

    end

  end
end
