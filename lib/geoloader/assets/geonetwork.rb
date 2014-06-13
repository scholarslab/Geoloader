
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
          :categories   => get_list_parameter("categories"),
          :keywords     => get_list_parameter("keywords"),
          :title        => @description.title.to_s,
          :abstract     => @description.abstract.to_s,
          :wms_address  => wms_address,
          :wms_layers   => wms_layers
        )}`
      end

      #
      # Convert an array metadata attribute to a comma-delimited list.
      #
      def get_list_parameter(key)
        @description.metadata.fetch(key, []).join(",")
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
