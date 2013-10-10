
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'fileutils'
require 'nokogiri'

module Geoloader
  class Asset

    attr_reader :file_name, :file_path, :base_name

    # @param [String] file_path
    def initialize(file_path)
      @file_path = file_path
      @base_name = File.basename(@file_path, ".*")
    end

    # Read the asset's XML file.
    #
    # @return [String]
    def get_xml
      File.read("#{@file_path}.xml")
    end

  end
end
