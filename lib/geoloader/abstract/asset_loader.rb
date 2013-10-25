
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

      # Store the manifest, alias the workspace.
      @manifest = Confstruct::Configuration.new(manifest)
      @workspace = @manifest.WorkspaceName

      # Connect to Geoserver and Solr.
      @geoserver = Geoloader::Geoserver.new
      @solr = Geoloader::Solr.new

      # Ensure that the workspace existson Geoserver.
      @geoserver.ensure_workspace(@workspace)

    end

  end
end
