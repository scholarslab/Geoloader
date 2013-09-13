
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'fileutils'

module Geoloader
  class Geotiff

    # Copy the input file for processing.
    # @param [String] path
    # @param [String] suffix
    def initialize path, suffix = "processed"
      @path = "#{File.dirname(path)}/#{File.basename(path, ".tif")}.#{suffix}.tif"
      FileUtils.cp path, @path
    end

    # Remove black borders created by ArcGIS.
    def remove_border
      system "gdalwarp -srcnodata 0 -dstalpha #{@path} #{@path}"
    end

    # Add a well-formed EPSG:4326 header.
    def build_header
      system "gdal_translate -of GTiff -a_srs EPSG:4326 #{@path} #{@path}_"
      FileUtils.rm @path
      FileUtils.mv "#{@path}_", @path
    end

    def process
      remove_border
      build_header
    end

  end
end
