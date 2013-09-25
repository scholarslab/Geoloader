
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
      @file_path = "#{@config.pending}/#{@file_name}"
      @base_name = File.basename @file_name, ".*"
      @processed = false
    end

    # Read the corresponding metadata file.
    #
    # @return [String]
    def xml
      File.read "#{@file_path}.xml"
    end

    # Prepare the file for upload.
    def process
      @processed = true
    end

    # Has the file been processed?
    #
    # @return [Boolean]
    def processed?
      @processed
    end

  end
end
