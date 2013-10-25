
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

      # Set the manifest, alias the workspace.
      @manifest = Confstruct::Configuration.new(manifest)
      @workspace = @manifest.WorkspaceName

      # Initialize service wrappers.
      @geoserver = Geoloader::Geoserver.new
      @solr = Geoloader::Solr.new

      # Ensure that the workspace exists.
      @geoserver.ensure_workspace(@workspace)

    end

  end
end
