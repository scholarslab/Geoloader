
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  module Loaders

    class Loader

      #
      # Perform or enqueue an upload.
      #
      # @param [String] file_path
      # @param [Hash] options
      #
      def self.load_or_enqueue(file_path, options)
        if options[:queue]
          Resque.enqueue(self, file_path, options[:workspace], options[:description])
        else
          self.perform(file_path, options[:workspace], options[:description])
        end
      end

      #
      # Perform an upload (used by Resque).
      #
      # @param [String] file_path
      # @param [String] workspace
      # @param [String] desc_path
      #
      def self.perform(file_path, workspace, desc_path = nil)
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
      def initialize(file_path, workspace, desc_path = nil)

        @file_path = file_path
        @desc_path = desc_path
        
        # If no workspace is provided, revert to the default.
        @workspace = (workspace or Geoloader.config.workspaces.production)

      end

    end

  end
end
