
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "fileutils"
require "zip"

module Geoloader
  module Assets

    module Geonetwork

      #
      # Read the raw ESRI XML.
      #
      def esri_xml
        File.read("#{@file_path}.xml")
      end

      #
      # Get the ESRI uuid.
      #
      def esri_uuid
        Nokogiri::XML(esri_xml).at_xpath("//thesaName/@uuidref").value
      end

      #
      # Convert the ESRI XML into a iso19139 record.
      #
      def iso19139_xml

        params = xslt_params({
          :abstract     => @description.abstract,
          :title        => @description.title,
          :wms_address  => "#{Geoloader.config.geoserver.url}/wms",
          :wms_layers   => "#{@workspace}:#{@file_base}"
        })

        `saxon #{@file_path}.xml #{Geoloader.gem_dir}/iso19139.xsl #{params}`

      end

      #
      # Convert a hash to a Saxon XSLT parameter string.
      #
      # @param [Hash] params
      #
      def xslt_params(params)
        params.map { |k, v| "#{k}=#{v}" }.join(" ")
      end

    end

  end
end
