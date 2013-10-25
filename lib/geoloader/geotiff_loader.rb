
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class GeotiffLoader < AssetLoader

    #
    # Construct the asset instance.
    #
    def create_asset
      @asset = Geoloader::Geotiff.new(@file_path, @workspace)
    end

    #
    # Post-process the file and push to Geoserver.
    #
    def load_geoserver
      @asset.make_borders_transparent
      @asset.reproject_to_4326
      @geoserver.create_coveragestore(@asset)
    end

    #
    # Add a document to the Solr index.
    #
    def load_solr
      @solr.create_document(@asset, @manifest)
    end

  end
end
