
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "fileutils"

module Geoloader
  class Geotiff < Asset

    #
    # Remove the black borders added by ArcMap.
    #
    def remove_borders
      system "gdalwarp -srcnodata 0 -dstalpha #{@file_path} #{@file_path}"
    end

    #
    # (Re)build a EPSG:4326 header.
    #
    def project_to_4326
      system "gdal_translate -of GTiff -a_srs EPSG:4326 #{@file_path} #{@file_path}_"
      FileUtils.rm(@file_path)
      FileUtils.mv("#{@file_path}_", @file_path)
    end

  end
end
