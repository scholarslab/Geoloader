
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=80;

module Geoloader
  class Geotiff

    def initialize(dir)
      @dir = dir 
    end

    def remove_border(old_file)
      command = "gdalwarp -srcnodata 0 -dstalpha"
      exec(old_file, '_border', command)
    end

    def build_header(old_file)
      command = "gdal_translate -of GTiff -a_srs EPSG:4326"
      exec(old_file, '_header', command)
    end

    private

    def exec(old_file, suffix, command)
      new_file = File.basename(file, ".tif") + "#{suffix}.tif"
      system command + " #{old_file} #{@dir}/#{new_file}"
    end

  end
end
