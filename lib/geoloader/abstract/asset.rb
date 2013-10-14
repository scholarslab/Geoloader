
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

    # Form the file path with a given extension.
    #
    # @param  [String] ext
    # @return [String]
    def ext_path(ext)
      "#{File.dirname(@file_path)}/#{@base_name}#{ext}"
    end

    # Read the asset's XML file.
    #
    # @return [String]
    def get_xml
      xslt_path = File.expand_path(Geoloader.config.geonetwork.xslt)
      system "saxon #{@file_path}.xml #{xslt_path} #{xslt_params} > #{ext_path('.geoloader.xml')}"
      File.read(ext_path(".geoloader.xml"))
    end

    # Form CLI parameters for XSLT transform.
    #
    # @return [String]
    def xslt_params
      [
        "geoserver_url='#{Geoloader.config.geoserver.url}'",
        "resource='#{Geoloader.config.geoserver.workspace}:#{@base_name}'"
      ].join(" ")
    end

  end
end
