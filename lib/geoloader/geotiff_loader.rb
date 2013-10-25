
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
      new(file_path, manifest).load
    end

    #
    # Construct the asset instance.
    #
    # @param [String] file_name
    # @param [Hash] manifest
    #
    def initialize(file_path, manifest)
      super
      @geotiff = Geoloader::Geotiff.new(file_path, @workspace)
    end

    #
    # Load the asset to Geoserver and Solr.
    #
    def load
      @geotiff.stage do |geotiff|

        # (1) Post-process.
        geotiff.remove_border
        geotiff.convert_to_4326

        # (2) Push to Geoserver.
        @geoserver.create_coveragestore(geotiff)

        # (3) Push to Solr.
        @solr.create_document(geotiff, @manifest)

      end
    end

  end
end
