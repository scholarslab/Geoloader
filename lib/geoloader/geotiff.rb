
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'fileutils'

module Geoloader
  class Geotiff < Asset

    attr_reader :processed_path

    # Copy the file for post-processing.
    #
    # @param [String] file_name
    def initialize file_name
      super file_name
      @processed_path = "#{Geoloader.config.directory}/#{@base_name}.geoloader.tif"
      FileUtils.cp @file_path, @processed_path
    end

    # Remove the black borders added by ArcMap.
    def remove_border
      system "gdalwarp -srcnodata 0 -dstalpha #{@processed_path} #{@processed_path}"
    end

    # (Re)build a EPSG:4326 header.
    def build_header
      system "gdal_translate -of GTiff -a_srs EPSG:4326 #{@processed_path} #{@processed_path}_"
      FileUtils.rm @processed_path
      FileUtils.mv "#{@processed_path}_", @processed_path
    end

  end
end
