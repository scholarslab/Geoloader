
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class GeotiffLoader < AssetLoader

    attr_reader :geotiff

    @queue = :geoloader

    #
    # Perform an upload (used by Resque).
    #
    # @param [String] file_name
    # @param [Hash] manifest
    #
    def self.perform(file_path, manifest)
      Geoloader::GeotiffLoader.new(file_path, manifest).load
    end

    #
    # Consruct the asset instance.
    #
    # @param [String] file_name
    # @param [Hash] manifest
    #
    def initialize(file_path, manifest)
      super
      @asset = Geoloader::Geotiff.new(file_path)
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
      @geoserver.create_coveragestore(@asset, @manifest.WorkspaceName)

      # (3) Push to Solr.
      @solr.create_document(@asset, @manifest)

      # (4) Cleanup.
      @asset.delete_copies

    end

  end
end
