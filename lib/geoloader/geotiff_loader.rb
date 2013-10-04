
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class GeotiffLoader

    attr_reader :geotiff, :geoserver

    # @param [String] file_path
    def initialize(file_path)
      @geotiff    = Geoloader::Geotiff.new(file_path)
      @geoserver  = Geoloader::Geoserver.new
      @geonetwork = Geoloader::Geonetwork.new
    end

    def load
      begin

        # Prepare the file.
        @geotiff.remove_border
        @geotiff.build_header

        # Push to Geoserver/Geonetwork.
        @geoserver.create_coveragestore(@geotiff)
        @geonetwork.create_record(@geotiff)

      rescue
        # TODO: Failure.
      else
        # TODO: Success.
      end
    end

  end
end
