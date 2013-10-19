
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class AssetLoader

    attr_reader :geoserver, :solr

    #
    # Store metadata, create service wrappers.
    #
    # @param [String] file_name
    # @param [Hash] manifest
    #
    def initialize(file_path, manifest)

      @manifest   = Confstruct::Configuration.new(manifest)
      @solr       = Geoloader::Solr.new
      @geoserver  = Geoloader::Geoserver.new

      # Ensure that the Geoserver workspace exists.
      @geoserver.ensure_workspace(@manifest.workspace)

    end

  end
end
