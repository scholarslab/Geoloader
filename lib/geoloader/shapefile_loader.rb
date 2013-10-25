
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class ShapefileLoader < AssetLoader

    attr_reader :shapefile

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
    def load(steps = [:postgis, :geoserver, :solr])
      @shapefile.stage do
        steps.each do |step|
          send("load_#{step}")
        end
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
