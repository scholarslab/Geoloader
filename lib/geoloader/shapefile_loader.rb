
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class ShapefileLoader

    # Create file and service instances.
    #
    # @param [String] file_name
    def initialize file_name
      @shapefile  = Geoloader::Shapefile.new file_name
      @postgis    = Geoloader::Postgis.new
      @geoserver  = Geoloader::Geoserver.new
      @geonetwork = Geoloader::Geonetwork.new
    end

    # Process and upload the geotiff.
    def work
      begin
        @postgis.add_table @shapefile
        @geoserver.publish_table @shapefile
        @geonetwork.metadata_insert @shapefile
      rescue
        # Failure.
      else
        # Success.
      end
    end

  end
end
