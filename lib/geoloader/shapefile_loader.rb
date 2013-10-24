
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class ShapefileLoader < AssetLoader

    attr_reader :shapefile

    @queue = :geoloader

    #
    # Perform an upload (used by Resque).
    #
    # @param [String] file_name
    # @param [Hash] manifest
    #
    def self.perform(file_path, manifest)
      Geoloader::ShapefileLoader.new(file_path, manifest).load
    end

    #
    # Construct the asset instance.
    #
    # @param [String] file_name
    # @param [Hash] manifest
    #
    def initialize(file_path, manifest)
      super
      @shapefile = Geoloader::Shapefile.new(file_path, @manifest.WorkspaceName)
    end

    #
    # Load the asset to Geoserver and Solr.
    #
    def load
      @shapefile.copy do |file|

        # (1) Create database.
        file.create_database
        file.enable_postgis
        file.insert_tables

        # (2) Push to Geoserver.
        @geoserver.create_datastore(file)
        @geoserver.create_featuretypes(file)

        # (3) Push to Solr.
        @solr.create_document(file, @manifest)

        # (4) Cleanup.
        file.disconnect

      end
    end

  end
end
