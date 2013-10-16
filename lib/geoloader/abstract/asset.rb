
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'fileutils'
require 'nokogiri'

module Geoloader
  class Asset

    attr_reader :file_path, :base_name, :uuid, :slug

    # Store the original file path and base name.
    #
    # @param [String] file_path
    def initialize(file_path)

      @file_path = file_path
      @base_name = File.basename(@file_path, ".*")

      # Query ESRI XML for uuid and slug.
      @esri_xml = Nokogiri::XML(File.read("#{@file_path}.xml"))
      @uuid = @esri_xml.at_xpath("//thesaName/@uuidref").content
      @slug = @esri_xml.at_xpath("//itemName").content

    end

  end
end
