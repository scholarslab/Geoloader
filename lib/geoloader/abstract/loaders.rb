
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class Loader

    attr_reader :geoserver, :solr

    #
    # Perform an upload (used by Resque).
    #
    # @param [String] file_name
    # @param [String] workspace
    #
    def self.perform(file_path, workspace)
      new(file_path, workspace).load
    end

    #
    # Initialize service wrappers, create workspace.
    #
    # @param [String] file_name
    # @param [String] workspace
    #
    def initialize(file_path, workspace)

      @file_path = file_path
      @workspace = workspace

      # Initialize Geoserver / Solr.
      @geoserver = Geoloader::Geoserver.new
      @solr = Geoloader::Solr.new

      # Ensure that the workspace exists.
      @geoserver.ensure_workspace(@workspace)

    end

  end
end
