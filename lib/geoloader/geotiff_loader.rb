
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class GeotiffLoader < AssetLoader

    attr_reader :geotiff

    #
    # Consruct the asset instance.
    #
    # @param [String] file_name
    # @param [Hash] metadata
    #
    def initialize(file_path, metadata)
      @asset = Geoloader::Geotiff.new(file_path)
      super
    end

    #
    # Load the asset to Geoserver and Solr.
    #
    def load

      # (1) Process the file.
      @asset.create_copies
      @asset.remove_border
      @asset.convert_to_4326

      # (2) Push to Geoserver.
      @geoserver.create_coveragestore(@asset, @workspace)

      # (3) Push to Solr.
      @solr.create_document(@asset, @metadata)

      # (4) Cleanup.
      @asset.delete_copies

    end

  end
end
