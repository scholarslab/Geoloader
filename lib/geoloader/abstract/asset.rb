
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'fileutils'
require 'nokogiri'

module Geoloader
  class Asset

    attr_reader :file_path, :base_name, :uuid

    #
    # Load the ESRI XML and cache the uuid.
    #
    # @param [String] file_path
    #
    def initialize(file_path)

      @file_path = file_path
      @base_name = File.basename(@file_path, ".*")

      # Store the ESRI uuid.
      @esri_xml = Nokogiri::XML(File.read("#{@file_path}.xml"))
      @uuid = "#{@esri_xml.at_xpath("//thesaName/@uuidref").content}-#{@base_name}"

    end

    #
    # Copy the file and its siblings for manipulation.
    #
    def create_copies

      # Create the upload archive directory.
      @archive = "#{File.expand_path(Geoloader.config.archive)}/#{Time.now.to_i}"
      FileUtils.mkdir(@archive)

      # Copy the assets into the archive.
      files = Dir.glob("#{File.dirname(file_path)}/#{@base_name}.*")
      FileUtils.cp(files, @archive)

      # Set the working file path.
      @file_path = "#{@archive}/#{File.basename(file_path)}"

    end

    #
    # Delete the working copies.
    #
    def delete_copies
      FileUtils.rm_rf(@archive)
    end

  end
end
