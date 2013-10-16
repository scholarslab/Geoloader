
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class ShapefileLoader < Loader

    attr_reader :shapefile

    # Create the file asset.
    #
    # @param [String] file_name
    def initialize(file_name)
      @shapefile = Geoloader::Shapefile.new(file_name)
      super()
    end

    def load

      # Create database.
      @shapefile.create_database
      @shapefile.connect
      @shapefile.generate_sql
      @shapefile.source_sql

      # Push to Geoserver/Solr.
      @geoserver.create_datastore(@shapefile)
      @geoserver.create_featuretypes(@shapefile)
      @solr.create_document(@shapefile)

      # Close connection.
      @shapefile.disconnect

    end

    def unload
      @geoserver.delete_datastore(@shapefile)
      @shapefile.drop_database
    end

  end
end
