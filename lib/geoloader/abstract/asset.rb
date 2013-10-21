
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'fileutils'
require 'digest/sha1'

module Geoloader
  class Asset

    attr_reader :file_path, :base_name, :workspace, :id

    #
    # Construct an id from the workspace adn base name.
    #
    # @param [String] file_path
    # @param [String] workspace
    #
    def initialize(file_path, workspace)

      @file_path = file_path
      @base_name = File.basename(@file_path, ".*")
      @workspace = workspace

      # Generate a Solr id.
      @id = Digest::SHA1.hexdigest("#{@workspace}_#{@base_name}")

    end

    #
    # Copy the file and its siblings for manipulation.
    #
    def create_copies

      # Create the working directory.
      @archive = "#{File.expand_path(Geoloader.config.archive)}/#{Time.now.to_i}"
      FileUtils.mkdir(@archive)

      # Copy the assets into the archive.
      files = Dir.glob("#{File.dirname(@file_path)}/#{@base_name}.*")
      FileUtils.cp(files, @archive)

      # Update the working file path.
      @file_path = "#{@archive}/#{File.basename(@file_path)}"

    end

    #
    # Delete the working copies.
    #
    def delete_copies
      FileUtils.rm_rf(@archive)
    end

  end
end
