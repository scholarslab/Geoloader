
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class ShapefileLoader

    # @param [String] file_name
    def initialize(file_name)
      @shapefile = Geoloader::Shapefile.new(file_name)
      @geoserver = Geoloader::Geoserver.new
    end

    def load
      begin

        # Create SQL from shapefile.
        @shapefile.generate_sql
        @shapefile.create_database
        @shapefile.source_sql

        # Add datastore/layers to Geoserver.
        @geoserver.publish_database(shapefile)
        @geoserver.publish_tables(shapefile)

      rescue
        # TODO: Failure.
      else
        # TODO: Success.
      end
    end

    def unload
      # TODO
    end

  end
end
