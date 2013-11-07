
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class GeoserverShapefileLoader < Loader

    include GeoserverLoader
    include ShapefileLoader

    @queue = :geoloader

    #
    # Push a Shapefile to Geoserver.
    #
    def load
      @shapefile.stage do
        @geoserver.create_datastore(@shapefile)
      end
    end

  end
end
