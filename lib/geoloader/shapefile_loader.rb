
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
      new(file_path, manifest).load
    end

    #
    # Construct the asset instance.
    #
    # @param [String] file_name
    # @param [Hash] manifest
    #
    def initialize(file_path, manifest)
      super
      @shapefile = Geoloader::Shapefile.new(file_path, @workspace)
    end

    #
    # Distpatch loading steps.
    #
    # @param [Array] steps
    #
    def load
      @shapefile.stage do

        # (1) Create database.
        @shapefile.create_database!
        @shapefile.insert_tables

        # (2) Push to Geoserver.
        @geoserver.create_datastore(@shapefile)
        @geoserver.create_featuretypes(@shapefile)

        # (3) Push to Solr.
        @solr.create_document(@shapefile, @manifest)

        # (4) Cleanup.
        @shapefile.disconnect!

      end
    end

  end
end
