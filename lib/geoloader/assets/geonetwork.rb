
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "fileutils"
require "cgi"

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
      # Convert the ESRI XML into a iso19139 record.
      #
      def iso19139_xml
        `saxon #{@file_path}.xml #{Geoloader.gem_dir}/iso19139.xsl #{xslt_params(
          :identifier   => @uuid,
          :categories   => @description.metadata["categories"].join(','),
          :keywords     => @description.metadata["keywords"].join(','),
          :title        => @description.title.to_s,
          :abstract     => @description.abstract.to_s,
          :wms_address  => wms_address,
          :wms_layers   => wms_layers
        )}`
      end

      #
      # Convert a hash to a Saxon XSLT parameter string.
      #
      # @param [Hash] params
      #
      def xslt_params(params)
        params.map { |k, v| "#{k}='#{CGI::escapeHTML(v)}'" }.join(" ")
      end

    end

  end
end
