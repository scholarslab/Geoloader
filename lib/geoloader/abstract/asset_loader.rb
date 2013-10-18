
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
      @geoserver  = Geoloader::Geoserver.new
      @solr       = Geoloader::Solr.new

      # Create the Geoserver workspace.
      @geoserver.ensure_workspace(@manifest.workspace)

    end

  end
end
