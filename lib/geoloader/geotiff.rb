
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class Geotiff

    def initialize(file)
      @dir = File.dirname(file) 
      @file = File.basename(file)
      @tmp_file = @file
    end

    def remove_border
      command = "gdalwarp -srcnodata 0 -dstalpha"
      execute(@tmp_file, '_border', command)
    end

    def rebuild_header
      command = "gdal_translate -of GTiff -a_srs EPSG:4326"
      execute(@tmp_file, '_header', command)
    end

    def cleanup
      FileUtils.rm "#{@dir}/#{@file}"
      FileUtils.mv "#{@dir}/#{@tmp_file}" "#{@dir}/#{@file}"
    end

    private

    def execute(file, suffix, command)
      new_file = File.basename(file, ".tif") + "#{suffix}.tif"
      system command + " #{file} #{@dir}/#{new_file}"
      @tmp_file = new_file
    end

  end
end
