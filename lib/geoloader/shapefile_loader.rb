
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class ShapefileLoader < AssetLoader

    attr_reader :shapefile
    @queue = :geoloader

    # TODO|dev
    def self.perform(file_path, metadata)
      loader = self.class.new(file_path, metadata)
      loader.load
    end

    #
    # Construct the asset instance.
    #
    # @param [String] file_name
    # @param [Hash] metadata
    #
    def initialize(file_path, metadata)
      @asset = Geoloader::Shapefile.new(file_path)
      super
    end

    #
    # Load the asset to Geoserver and Solr.
    #
    def load

      # (1) Create database.
      @shapefile.create_copies
      @shapefile.create_database
      @shapefile.connect
      @shapefile.insert_tables

      # (2) Push to Geoserver.
      @geoserver.create_datastore(@asset, @workspace)
      @geoserver.create_featuretypes(@asset, @workspace)

      # (3) Push to Solr.
      @solr.create_document(@asset, @metadata)

      # (4) Cleanup.
      @shapefile.disconnect
      @shapefile.delete_copies

    end

    #
    # Remove the asset from Geoserver and Solr.
    #
    def unload

      # (1) Delete from Solr.
      @solr.delete_document(@asset)

      # (2) Delete from Geoserver.
      @geoserver.delete_datastore(@asset, @workspace)

      # (3) Drop database.
      @shapefile.drop_database

    end

  end
end
