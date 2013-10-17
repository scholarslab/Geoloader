
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
      @solr       = Geoloader::Solr.new
      @geoserver  = Geoloader::Geoserver.new
      @metadata   = metadata
    end

  end
end
