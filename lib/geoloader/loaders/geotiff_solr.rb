
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class GeotiffSolrLoader < Loader

    include GeotiffLoader
    include SolrLoader

    @queue = :geoloader

    #
    # Push a GeoTIFF to Solr.
    #
    def load
      @geotiff.stage do
        @solr.create_document(@geotiff)
      end
    end

  end
end
