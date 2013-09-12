
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class Geotiff

    def initialize(file)
      @file = File.basename(file)
      @dir = File.dirname(file) 
    end

    def remove_border()
      command = "gdalwarp -srcnodata 0 -dstalpha"
      execute(@file, '_border', command)
    end

    def build_header()
      command = "gdal_translate -of GTiff -a_srs EPSG:4326"
      execute(@file, '_header', command)
    end

    private

    def execute(file, suffix, command)
      new_file = File.basename(file, ".tif") + "#{suffix}.tif"
      system command + " #{file} #{@dir}/#{new_file}"
      @file = new_file
    end

  end
end
