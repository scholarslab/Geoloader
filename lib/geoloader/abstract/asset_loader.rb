
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class AssetLoader

    attr_reader :geoserver, :solr

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
    # Store metadata, create service wrappers.
    #
    # @param [String] file_name
    # @param [Hash] manifest
    #
    def initialize(file_path, manifest)

      @file_path = file_path

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
