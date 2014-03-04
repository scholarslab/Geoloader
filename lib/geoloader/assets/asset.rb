
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "fileutils"

module Geoloader
  module Assets

    class Asset

      attr_reader :file_path, :file_base, :workspace, :slug

      #
      # Set the basename and workspace-prefixed slug, parse the description.
      #
      # @param [String] file_path
      # @param [String] workspace
      # @param [String] desc_path
      #
      def initialize(file_path, workspace, desc_path)

        @file_path = file_path
        @workspace = workspace
        @desc_path = desc_path

        # File name, with and without extension.
        @file_base = File.basename(@file_path, ".*")
        @file_name = File.basename(@file_path)

        # Set a workspace-prefixed slug.
        @slug = "#{@workspace}_#{@file_base}"

      end

      #
      # Create working copies, yield to a block, remove the copies.
      #
      def stage

        @tempdir = Dir.mktmpdir

        begin

          # Copy the assets into the temp dir.
          files = Dir.glob("#{File.dirname(@file_path)}/#{@file_base}.*")
          FileUtils.cp(files, @tempdir)

          # Change into the temp dir.
          FileUtils.cd(@tempdir) do yield end

        ensure

          # Delete the copies.
          FileUtils.remove_entry @tempdir

        end

      end

    end

  end
end
