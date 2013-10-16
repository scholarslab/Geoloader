
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class AssetLoader

    attr_reader :geoserver, :solr

    # Connect to Geoserver and Solr.
    def initialize
      @geoserver = Geoloader::Geoserver.new
      @solr = Geoloader::Solr.new
    end

  end
end
