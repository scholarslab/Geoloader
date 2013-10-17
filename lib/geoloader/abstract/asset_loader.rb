
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class AssetLoader

    attr_reader :geoserver, :solr

    #
    # Store metadata, create service wrappers.
    #
    # @param [String] file_name
    # @param [Hash] metadata
    #
    def initialize(file_path, metadata)
      @metadata = metadata
      @geoserver = Geoloader::Geoserver.new(@metadata["workspace"])
      @solr = Geoloader::Solr.new
    end

  end
end
