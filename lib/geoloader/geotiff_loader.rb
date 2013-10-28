
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class GeotiffLoader < AssetLoader

    attr_reader :geotiff

    #
    # Initialize the GeoTIFF instance.
    #
    def initialize(*args)
      super
      @geotiff = Geoloader::Geotiff.new(@file_path, @workspace)
    end

    #
    # Push a GeoTIFF to Geoserver and Solr.
    #
    def load
      @geotiff.stage do

        # (1) Prepare the file.
        @geotiff.make_borders_transparent
        @geotiff.project_to_4326

        # (2) Push to Geoserver.
        @geoserver.create_coveragestore(@geotiff)

        # (3) Push to Solr.
        @solr.create_document(@geotiff, @manifest)

      end
    end

  end
end
