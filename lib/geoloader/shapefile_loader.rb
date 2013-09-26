
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class ShapefileLoader

    # @param [String] file_name
    def initialize file_name
      @file_name = file_name
    end

    def work
      begin

        # Create SQL from shapefile.
        shapefile = Geoloader::Shapefile.new @file_name
        shapefile.generate_sql

        # Add PostGIS database.
        postgis = Geoloader::Postgis.new
        postgis.create_database shapefile
        postgis.source_sql shapefile

        # Add datastore/layers to Geoserver.
        geoserver = Geoloader::Geoserver.new
        geoserver.publish_database shapefile
        geoserver.publish_tables shapefile

      rescue
        # TODO: Failure.
      else
        # TODO: Success.
      end
    end

  end
end
