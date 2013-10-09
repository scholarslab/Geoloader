
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

    # Read the asset's XML file and transform it to ISO 19139.
    #
    # @return [String]
    def get_xml
      xml = Nokogiri::XML(File.read("#{@file_path}.xml"))
      self.class.get_xslt.transform(xml).to_s
    end

    # Load the ISO 19139 xslt.
    #
    # @return [Nokogiri::XSLT]
    def self.get_xslt
      path = File.expand_path("xslt/iso19139.xsl", File.dirname(__FILE__))
      Nokogiri::XSLT(File.read(path))
    end

  end
end
