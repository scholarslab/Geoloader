
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class ShapefileLoader < AssetLoader

    attr_reader :shapefile

    @queue = :geoloader

    #
    # Initialize the shapefile instance.
    #
    def initialize(*args)
      super
      @shapefile = Geoloader::Shapefile.new(@file_path, @workspace)
    end

    #
    # Push a Shapefile to PostGIS, Geoserver, Solr.
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

      end
    end

  end
end
