
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
      @shapefile = Geoloader::Shapefile.new(@file_path, @workspace)
    end

    #
    # Distpatch loading steps.
    #
    # @param [Array] steps
    #
    def load
      @shapefile.stage do
        load_postgis
        load_geoserver
        load_solr
      end
    end

    #
    # Create a PostGIS table and insert tables.
    #
    def load_postgis
      @shapefile.create_database!
      @shapefile.insert_tables
    end

    #
    # Create datastore on Geoserver.
    #
    def load_geoserver
      @geoserver.create_datastore(@shapefile)
      @geoserver.create_featuretypes(@shapefile)
    end

    #
    # Add a document to Solr.
    #
    def load_solr
      @solr.create_document(@shapefile, @manifest)
    end

  end
end
