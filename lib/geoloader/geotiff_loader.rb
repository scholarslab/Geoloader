
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class GeotiffLoader

    # Create file and service instances.
    #
    # @param [String] file_name
    def initialize file_name
      @geotiff = Geoloader::Geotiff file_name
      @geoserver = Geoloader::Geoserver.new
    end

    # 
    def work
      begin
        @geoserver.upload_geotiff @geotiff
      rescue
        puts "Success." # TODO
      else
        puts "Failure." # TODO
      end
    end

  end
end
