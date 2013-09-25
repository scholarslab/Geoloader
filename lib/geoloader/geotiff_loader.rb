
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class GeotiffLoader

    # Create file and service instances.
    #
    # @param [String] file_name
    def initialize file_name
      @geotiff    = Geoloader::Geotiff.new file_name
      @geoserver  = Geoloader::Geoserver.new
      @geonetwork = Geoloader::Geonetwork.new
    end

    # Process and upload the geotiff.
    def work
      begin
        @geoserver.upload_geotiff @geotiff
        @geonetwork.add_record    @geotiff
      rescue
        # Failure.
      else
        # Success.
      end
    end

  end
end
