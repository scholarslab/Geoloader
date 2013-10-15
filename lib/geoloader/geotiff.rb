
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'fileutils'

module Geoloader
  class Geotiff < Asset

    attr_reader :processed_path

    # Copy the file for post-processing.
    #
    # @param [String] file_path
    def initialize(file_path)
      super
      @processed_path = "#{File.dirname(@file_path)}/#{@base_name}.geoloader.tif"
      FileUtils.cp(@file_path, @processed_path)
    end

    # Remove the black borders added by ArcMap.
    def remove_border
      system "gdalwarp -srcnodata 0 -dstalpha #{@processed_path} #{@processed_path}"
    end

    # (Re)build a EPSG:4326 header.
    def convert_to_4326
      system "gdal_translate -of GTiff -a_srs EPSG:4326 #{@processed_path} #{@processed_path}_"
      FileUtils.rm(@processed_path)
      FileUtils.mv("#{@processed_path}_", @processed_path)
    end

  end
end
