
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'fileutils'

module Geoloader
  class Geotiff < Asset

    attr_reader :base, :path

    # Copy the file for manipulation.
    #
    # @param [String] path
    # @param [String] suffix
    def initialize path, suffix = "processed"
      @base = File.basename(path, ".tif")
      @path = "#{File.dirname(path)}/#{@base}.#{suffix}.tif"
      FileUtils.cp path, @path
    end

    # Remove the black borders added by ArcMap.
    def remove_border
      system "gdalwarp -srcnodata 0 -dstalpha #{@path} #{@path}"
    end

    # (Re)build a EPSG:4326 header.
    def build_header
      system "gdal_translate -of GTiff -a_srs EPSG:4326 #{@path} #{@path}_"
      FileUtils.rm @path
      FileUtils.mv "#{@path}_", @path
    end

    # Prepare the file for Geoserver.
    def prepare
      remove_border
      build_header
    end

  end
end
