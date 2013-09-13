
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'fileutils'

module Geoloader
  class Geotiff

    def initialize path, suffix = "processed"
      @path = "#{File.dirname(path)}/#{File.basename(path, ".tif")}.#{suffix}.tif"
      FileUtils.cp path, @path
    end

    def remove_border
      system "gdalwarp -srcnodata 0 -dstalpha #{@path} #{@path}"
    end

    def rebuild_header
      system "gdal_translate -of GTiff -a_srs EPSG:4326 #{@path} #{@path}_"
      FileUtils.rm @path
      FileUtils.mv "#{@path}_", @path
    end

    def process
      remove_border
      rebuild_header
    end

  end
end
