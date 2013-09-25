
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class ShapefileLoader

    # @param [String] file_name
    def initialize file_name
      @file_name = file_name
      #@shapefile  = Geoloader::Shapefile.new file_name
      #@postgis    = Geoloader::Postgis.new
      #@geoserver  = Geoloader::Geoserver.new
      #@geonetwork = Geoloader::Geonetwork.new
    end

    def work
      begin

        # Create SQL from shapefile.
        shapefile = Geoloader::Shapefile.new @file_name
        shapefile.generate_sql

        # Add the table(s) to PostGIS.
        postgis = Geoloader::Postgis.new
        postgis.add_table shapefile

        # Push the table to Geoserver.
        geoserver = Geoloader::Geoserver.new
        geoserver.publish_table shapefile

      rescue
        # TODO: Failure.
      else
        # TODO: Success.
      end
    end

  end
end
