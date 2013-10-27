
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class ShapefileLoader < AssetLoader

    def load

      @asset = Geoloader::Shapefile.new(@file_path, @workspace)

      @asset.stage do

        # (1) Create database.
        @asset.create_database!
        @asset.insert_tables

        # (2) Push to Geoserver.
        @geoserver.create_datastore(@asset)
        @geoserver.create_featuretypes(@asset)

        # (3) Push to Solr.
        @solr.create_document(@asset, @manifest)

      end

    end

  end
end
