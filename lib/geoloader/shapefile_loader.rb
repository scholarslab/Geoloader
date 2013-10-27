
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class ShapefileLoader < AssetLoader

    #
    # Construct the asset instance.
    #
    def before
      @asset = Geoloader::Shapefile.new(@file_path, @workspace)
    end

    #
    # Create a PostGIS table and insert tables.
    #
    def load_postgis
      @asset.create_database!
      @asset.insert_tables
    end

    #
    # Create datastore on Geoserver.
    #
    def load_geoserver
      @geoserver.create_datastore(@asset)
      @geoserver.create_featuretypes(@asset)
    end

    #
    # Add a document to Solr.
    #
    def load_solr
      @solr.create_document(@asset, @manifest)
    end

  end
end
