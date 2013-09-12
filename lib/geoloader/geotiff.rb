
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class Geotiff

    def initialize(path)
      @path = path
    end

    def prepare
      remove_border
      rebuild_header
    end

    private

    def remove_border
      system "gdalwarp -srcnodata 0 -dstalpha #{@path}"
    end

    def rebuild_header

      # Create a temporary copy with a well-formed header.
      tmp = "#{File.dirname(@path)}/#{File.basename(@path, ".tif")}_4326.tif"
      system "gdal_translate -of GTiff -a_srs EPSG:4326 #{@path} #{tmp}"

      # Replace the original with the copy.
      FileUtils.rm @path
      FileUtils.mv tmp @path

    end

  end
end
