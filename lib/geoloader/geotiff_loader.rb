
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class GeotiffLoader < AssetLoader

    def load

      @asset = Geoloader::Geotiff.new(@file_path, @workspace)

      @asset.stage do

        # (1) Prepare the file.
        @asset.remove_borders
        @asset.project_to_4326

        # (2) Push to Geoserver.
        @geoserver.create_coveragestore(@asset)

        # (3) Push to Solr.
        @solr.create_document(@asset, @manifest)

      end

    end

  end
end
