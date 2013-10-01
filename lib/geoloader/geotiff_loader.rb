
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class GeotiffLoader

    # @param [String] file_path
    def initialize(file_path)
      @geotiff    = Geoloader::Geotiff.new(file_path)
      @geoserver  = Geoloader::Geoserver.new
    end

    def load
      begin

        # Prepare the file.
        @geotiff.remove_border
        @geotiff.build_header

        # Push to Geoserver.
        @geoserver.create_coveragestore(@geotiff)

      rescue
        # TODO: Failure.
      else
        # TODO: Success.
      end
    end

  end
end
