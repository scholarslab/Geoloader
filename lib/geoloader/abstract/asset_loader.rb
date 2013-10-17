
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

      # Initialize service wrappers.
      @geoserver  = Geoloader::Geoserver.new
      @solr       = Geoloader::Solr.new

      # Create the Geoserver workspace.
      @workspace = @metadata["workspace"]
      @geoserver.create_workspace(@workspace) unless @geoserver.workspace_exists?(@workspace)

    end

  end
end
