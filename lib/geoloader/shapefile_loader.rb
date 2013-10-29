
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
      @shapefile = Geoloader::Asset.new(@file_path, @workspace)
    end

    #
    # Push a Shapefile to PostGIS, Geoserver, Solr.
    #
    def load
      @shapefile.stage do

        # (1) Push to Geoserver.
        @geoserver.create_datastore(@shapefile)

        # (2) Push to Solr.
        @solr.create_document(@shapefile)

      end
    end

  end
end
