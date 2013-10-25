
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
      @geotiff = Geoloader::Geotiff.new(@file_path, @workspace)
    end

    #
    # Load the asset to Geoserver and Solr.
    #
    # @param [Array] steps
    #
    def load(steps = [:geoserver, :solr])
      @geotiff.stage do
        steps.each do |step|
          send("load_#{step}")
        end
      end
    end

    #
    # Post-process the file and push to Geoserver.
    #
    def load_geoserver
      @geotiff.make_borders_transparent
      @geotiff.reproject_to_4326
      @geoserver.create_coveragestore(@geotiff)
    end

    #
    # Add a document to the Solr index.
    #
    def load_solr
      @solr.create_document(@geotiff, @manifest)
    end

  end
end
