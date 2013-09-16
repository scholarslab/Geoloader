
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'fileutils'

module Geoloader
  class Geotiff

    attr_reader :base, :path

    def initialize path, suffix = "processed"
      @base = File.basename(path, ".tif")
      @path = "#{File.dirname(path)}/#{@base}.#{suffix}.tif"
      FileUtils.cp path, @path
    end

    def remove_border
      system "gdalwarp -srcnodata 0 -dstalpha #{@path} #{@path}"
    end

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
