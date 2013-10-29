
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
    # Create working copies, yield to a block, remove the copies.
    #
    def stage
      enqueue
      begin
        yield
      ensure
        dequeue
      end
    end

    private

    #
    # Copy the file and its siblings for manipulation.
    #
    def enqueue

      # Create the warehouse directory.
      @copies = "#{File.dirname(@file_path)}/#{Time.now.to_i}"
      FileUtils.mkdir(@copies)

      # Copy the assets into the archive.
      files = Dir.glob("#{File.dirname(@file_path)}/#{@base_name}.*")
      FileUtils.cp(files, @copies)

      # Update the working file path, saving the original.
      @file_path_ = @file_path
      @file_path = "#{@copies}/#{File.basename(@file_path)}"

    end

    #
    # Delete the working copies, restore the original path.
    #
    def dequeue
      FileUtils.rm_rf(@copies)
      @file_path = @file_path_
    end

  end
end
