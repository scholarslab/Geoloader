
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class GeotiffLoader < AssetLoader

    attr_reader :geotiff

    # Create the file asset.
    #
    # @param [String] file_name
    def initialize(file_path)
      @geotiff = Geoloader::Geotiff.new(file_path)
      super()
    end

    def load

      # Prepare the file.
      @geotiff.remove_border
      @geotiff.convert_to_4326

      # Push to Geoserver / Solr.
      @geoserver.create_coveragestore(@geotiff)
      @solr.create_document(@geotiff)

    end

    def unload
      @geoserver.delete_coveragestore(@geotiff)
    end

  end
end
