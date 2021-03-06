
require "fileutils"

module Geoloader
  module Assets

    module Geotiff

      #
      # Remove the black borders added by ArcMap.
      #
      def make_borders_transparent
        gdal_command("gdalwarp -srcnodata 0 -dstalpha", @file_name)
      end

      #
      # (Re)build a EPSG:4326 header.
      #
      def reproject
        srs = Geoloader.config.geoserver.srs
        gdal_command("gdal_translate -of GTiff -a_srs #{srs}", @file_name)
      end

      private

      #
      # Run a gdal command on a file, replacing the original file.
      #
      # @param [String] command
      # @param [String] file_path
      #
      def gdal_command(command, file_path)
        `#{command} #{file_path} #{file_path}_`
        FileUtils.rm(file_path)
        FileUtils.mv("#{file_path}_", file_path)
      end

    end

  end
end
