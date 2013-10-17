
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class GeotiffLoader < AssetLoader

    attr_reader :geotiff

    # @param [String] file_name
    def initialize(file_path)
      @geotiff = Geoloader::Geotiff.new(file_path)
      super()
    end

    def load

      # (1) Process the file.
      @geotiff.remove_border
      @geotiff.convert_to_4326

      # (2) Push to Geoserver.
      @geoserver.create_coveragestore(@geotiff)

      # (3) Push to Solr.
      @solr.create_document(@geotiff)

    end

    def unload

      # (1) Delete from Goeserver.
      @geoserver.delete_coveragestore(@geotiff)

      # (2) Delete from Solr.
      @solr.delete_document(@geotiff)

    end

  end
end
