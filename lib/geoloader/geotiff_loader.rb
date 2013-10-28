
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class GeotiffLoader < AssetLoader

    attr_reader :geotiff

    #
    # Push a GeoTIFF to Geoserver and Solr.
    #
    def load

      @geotiff = Geoloader::Geotiff.new(@file_path, @workspace)

      @geotiff.stage do

        # (1) Prepare the file.
        @geotiff.remove_borders
        @geotiff.project_to_4326

        # (2) Push to Geoserver.
        @geoserver.create_coveragestore(@geotiff)

        # (3) Push to Solr.
        @solr.create_document(@geotiff, @manifest)

      end

    end

  end
end
