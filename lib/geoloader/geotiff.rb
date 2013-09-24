
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'fileutils'

module Geoloader
  class Geotiff < Asset

    attr_reader :gdal_path

    # Copy the file for post-processing.
    #
    # @param [String] filename
    # @param [String] suffix
    def initialize filename, suffix = "processed"
      super filename
      @gdal_path = "#{Geoloader.config.directory}/#{@basename}.#{suffix}.tif"
      FileUtils.cp @file_path, @gdal_path
    end

    # Remove the black borders added by ArcMap.
    def remove_border
      system "gdalwarp -srcnodata 0 -dstalpha #{@gdal_path} #{@gdal_path}"
    end

    # (Re)build a EPSG:4326 header.
    def build_header
      system "gdal_translate -of GTiff -a_srs EPSG:4326 #{@gdal_path} #{@gdal_path}_"
      FileUtils.rm @gdal_path
      FileUtils.mv "#{@gdal_path}_", @gdal_path
    end

    # Prepare the file for Geoserver.
    def prepare
      remove_border
      build_header
    end

  end
end
