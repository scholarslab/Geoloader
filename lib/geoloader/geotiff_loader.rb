
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class GeotiffLoader

    # @param [String] file_path
    def initialize(file_path)
      @file_path = file_path
    end

    def work
      begin

        # Prepare the file.
        geotiff = Geoloader::Geotiff.new(@file_path)
        geotiff.remove_border
        geotiff.build_header

        # Push to Geoserver.
        geoserver = Geoloader::Geoserver.new
        geoserver.upload_geotiff(geotiff)

      rescue
        # TODO: Failure.
      else
        # TODO: Success.
      end
    end

  end
end
