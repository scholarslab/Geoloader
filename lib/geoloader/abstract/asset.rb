
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'fileutils'
require 'nokogiri'

module Geoloader
  class Asset

    attr_reader :file_path, :base_name

    # Store the original file path and base name.
    #
    # @param [String] file_path
    def initialize(file_path)
      @file_path = file_path
      @base_name = File.basename(@file_path, ".*")
    end

    # Construct a file path with a given extension.
    #
    # @param  [String] ext
    # @return [String]
    def ext_path(ext)
      "#{File.dirname(@file_path)}/#{@base_name}#{ext}"
    end

  end
end
