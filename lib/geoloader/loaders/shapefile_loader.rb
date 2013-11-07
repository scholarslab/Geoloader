
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class ShapefileLoader < Loader

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

        # Push to Geoserver.
        @geoserver.create_datastore(@shapefile)

        # Push to Solr.
        @solr.create_document(@shapefile)

      end
    end

  end
end
