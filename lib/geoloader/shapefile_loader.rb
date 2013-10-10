
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class ShapefileLoader

    attr_reader :shapefile, :geoserver

    # @param [String] file_name
    def initialize(file_name)
      @shapefile  = Geoloader::Shapefile.new(file_name)
      @geoserver  = Geoloader::Geoserver.new
      @geonetwork = Geoloader::Geonetwork.new
    end

    def load

      # Create database.
      @shapefile.generate_sql
      @shapefile.create_database
      @shapefile.connect
      @shapefile.source_sql

      # Push to Geoserver/Geonetwork.
      @geoserver.create_datastore(@shapefile)
      @geoserver.create_featuretypes(@shapefile)
      #@geonetwork.create_record(@shapefile)

      # Close connection.
      @shapefile.disconnect

    end

    def unload
      @geoserver.delete_datastore(@shapefile)
      @shapefile.drop_database
    end

  end
end
