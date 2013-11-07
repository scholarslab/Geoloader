
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class SolrShapefileLoader < Loader

    include SolrLoader
    include ShapefileLoader

    @queue = :geoloader

    #
    # Push a Shapefile to Solr.
    #
    def load
      @shapefile.stage do
        @solr.create_document(@shapefile)
      end
    end

  end
end
