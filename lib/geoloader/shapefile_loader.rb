
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class ShapefileLoader < AssetLoader

    attr_reader :shapefile

    # @param [String] file_name
    def initialize(file_name)
      @shapefile = Geoloader::Shapefile.new(file_name)
      super()
    end

    def load

      # (1) Create database.
      @shapefile.create_database
      @shapefile.connect
      @shapefile.generate_sql
      @shapefile.source_sql

      # (2) Push to Geoserver.
      @geoserver.create_datastore(@shapefile)
      @geoserver.create_featuretypes(@shapefile)

      # (3) Push to Solr.
      @solr.create_document(@shapefile)

      # (4) Close connection.
      @shapefile.disconnect

    end

    def unload

      # (1) Delete from Solr.
      @solr.delete_document(@shapefile)

      # (2) Delete from Geoserver.
      @geoserver.delete_datastore(@shapefile)

      # (3) Drop database.
      @shapefile.drop_database

    end

  end
end
