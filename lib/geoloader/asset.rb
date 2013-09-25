
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'fileutils'

module Geoloader
  class Asset

    attr_reader :file_name, :file_path, :base_name

    # Compute the basename and filepath.
    #
    # @param [String] file_name
    def initialize file_name
      @file_name = file_name
      @file_path = "#{Geoloader.config.directory}/#{@file_name}"
      @base_name = File.basename @file_name, ".*"
      @processed = false
    end

    # Read the corresponding metadata file.
    #
    # @return [String]
    def xml
      File.read "#{@file_path}.xml"
    end

    # Prepared the file for upload.
    def process
      @processed = true
    end

    # Has the file been prepared for upload?
    #
    # @return [Boolean]
    def processed?
      @processed
    end

  end
end
