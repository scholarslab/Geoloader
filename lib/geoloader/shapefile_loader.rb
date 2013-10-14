
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class ShapefileLoader < Loader

    attr_reader :shapefile

    # @param [String] file_name
    def initialize(file_name)
      super
      @shapefile = Geoloader::Shapefile.new(file_name)
    end

    def load

      # Create database.
      @shapefile.create_database
      @shapefile.connect
      @shapefile.generate_sql
      @shapefile.source_sql

      # Push to Geoserver.
      @geoserver.create_datastore(@shapefile)
      @geoserver.create_featuretypes(@shapefile)
      @geonetwork.create_record(@shapefile)

      # Close connection.
      @shapefile.disconnect

    end

    def unload
      @geoserver.delete_datastore(@shapefile)
      @shapefile.drop_database
    end

  end
end
