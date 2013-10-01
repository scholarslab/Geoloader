
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class ShapefileLoader

    attr_reader :shapefile, :geoserver

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
        @geoserver.create_datastore(@shapefile)
        @geoserver.create_featuretypes(@shapefile)

        # Disconnect from PostGIS.
        @shapefile.disconnect

      rescue
        # TODO: Failure.
      else
        # TODO: Success.
      end
    end

  end
end
