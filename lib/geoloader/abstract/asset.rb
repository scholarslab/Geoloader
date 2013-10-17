
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'fileutils'
require 'nokogiri'

module Geoloader
  class Asset

    attr_reader :file_path, :base_name, :uuid, :slug

    # Load the ESRI XML and cache the uuid.
    #
    # @param [String] file_path
    def initialize(file_path)

      @file_path = file_path
      @base_name = File.basename(@file_path, ".*")

      # Cache the ESRI uuid.
      @esri_xml = Nokogiri::XML(File.read("#{@file_path}.xml"))
      @uuid = "#{@esri_xml.at_xpath("//thesaName/@uuidref").content}:#{@base_name}"

    end

  end
end
