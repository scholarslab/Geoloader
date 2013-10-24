
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
      @geotiff = Geoloader::Geotiff.new(file_path, @manifest.WorkspaceName)
    end

    #
    # Load the asset to Geoserver and Solr.
    #
    def load
      @geotiff.copy do |file|

        # (1) Post-process.
        file.remove_border
        file.convert_to_4326

        # (2) Push to Geoserver.
        @geoserver.create_coveragestore(file)

        # (3) Push to Solr.
        @solr.create_document(file, @manifest)

      end
    end

  end
end
