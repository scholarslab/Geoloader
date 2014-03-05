
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "fileutils"
require "zip"

module Geoloader
  module Assets

    module Geonetwork

      #
      # Form the WMS address.
      #
      def wms_address
        "#{Geoloader.config.geoserver.url}/wms"
      end

      #
      # Form the WMS layer string.
      #
      def wms_layers
        "#{@workspace}:#{@file_base}"
      end

      #
      # Get the ESRI uuid.
      #
      def esri_uuid
        Nokogiri::XML(esri_xml).at_xpath("//thesaName/@uuidref").value
      end

      #
      # Read the raw ESRI XML.
      #
      def esri_xml
        File.open("#{@file_path}.xml")
      end

      #
      # Convert the ESRI XML into a iso19139 record.
      #
      def iso19139_xml
        `saxon #{@file_path}.xml #{Geoloader.gem_dir}/iso19139.xsl #{xslt_params(
          :identifier   => @uuid,
          :title        => @description.title.to_s,
          :abstract     => @description.abstract.to_s,
          :wms_address  => @wms_address,
          :wms_layers   => @wms_layers
        )}`
      end

      #
      # Convert a hash to a Saxon XSLT parameter string.
      #
      # @param [Hash] params
      #
      def xslt_params(params)
        params.map { |k, v| "#{k}='#{v.inspect}'" }.join(" ")
      end

    end

  end
end
