
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "fileutils"
require "digest/sha1"

module Geoloader
  class Asset

    attr_reader :file_path, :base_name, :workspace, :slug

    #
    # Set the basename and workspace-prefixed slug.
    #
    # @param [String] file_path
    # @param [String] workspace
    #
    def initialize(file_path, workspace)

      @file_path = file_path
      @base_name = File.basename(@file_path, ".*")
      @workspace = workspace

      # Set a workspace-prefixed slug.
      @slug = "#{@workspace}_#{@base_name}"

    end

    #
    # Copy the file and its siblings for manipulation.
    #
    def create_copies

      # Create the warehouse directory.
      @warehouse = "#{File.dirname(@file_path)}/#{Time.now.to_i}"
      FileUtils.mkdir(@warehouse)

      # Copy the assets into the archive.
      files = Dir.glob("#{File.dirname(@file_path)}/#{@base_name}.*")
      FileUtils.cp(files, @warehouse)

      # Update the working file path.
      @file_path = "#{@warehouse}/#{File.basename(@file_path)}"

    end

    #
    # Delete the working copies.
    #
    def delete_copies
      FileUtils.rm_rf(@warehouse)
    end

  end
end
