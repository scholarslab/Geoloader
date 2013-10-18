
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class ShapefileLoader < AssetLoader

    attr_reader :shapefile

    @queue = :geoloader

    #
    # Perform an upload (used by Resque).
    #
    # @param [String] file_name
    # @param [Hash] metadata
    #
    def self.perform(file_path, metadata)
      Geoloader::ShapefileLoader.new(file_path, metadata).load
    end

    #
    # Construct the asset instance.
    #
    # @param [String] file_name
    # @param [Hash] metadata
    #
    def initialize(file_path, metadata)
      super
      @asset = Geoloader::Shapefile.new(file_path, @workspace)
    end

    #
    # Load the asset to Geoserver and Solr.
    #
    def load

      # (1) Create database.
      @asset.create_copies
      @asset.create_database
      @asset.connect
      @asset.insert_tables

      # (2) Push to Geoserver.
      @geoserver.create_datastore(@asset, @workspace)
      @geoserver.create_featuretypes(@asset, @workspace)

      # (3) Push to Solr.
      @solr.create_document(@asset, @metadata)

      # (4) Cleanup.
      @asset.disconnect
      @asset.delete_copies

    end

  end
end
