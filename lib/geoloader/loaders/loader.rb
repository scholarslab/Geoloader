
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  module Loaders

    class Loader

      #
      # Perform an upload (used by Resque).
      #
      # @param [String] file_path
      # @param [String] workspace
      # @param [String] desc_path
      #
      def self.perform(file_path, workspace, desc_path)
        new(file_path, workspace, desc_path).load
        puts "Loaded #{File.basename(file_path)}."
      end

      #
      # Set the file path and workspace.
      #
      # @param [String] file_path
      # @param [String] workspace
      # @param [String] desc_path
      #
      def initialize(file_path, workspace, desc_path)
        @file_path = file_path
        @workspace = workspace
        @desc_path = desc_path
      end

    end

  end
end
