
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class ShapefileLoader < AssetLoader

    attr_reader :shapefile

    #
    # @param [String] file_name
    # @param [Hash] metadata
    #
    def initialize(file_path, metadata)
      @shapefile = Geoloader::Shapefile.new(file_path)
      super
    end

    def load

      # (1) Create database.
      @shapefile.create_copies
      @shapefile.create_database
      @shapefile.connect
      @shapefile.insert_tables

      # (2) Push to Geoserver.
      @geoserver.create_datastore(@shapefile)
      @geoserver.create_featuretypes(@shapefile)

      # (3) Push to Solr.
      @solr.create_document(@shapefile, @metadata)

      # (4) Cleanup.
      @shapefile.disconnect
      @shapefile.delete_copies

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
