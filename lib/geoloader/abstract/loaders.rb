
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader

  class Loader

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
    # Set the file path and workspace.
    #
    # @param [String] file_name
    # @param [String] workspace
    # @param [Hash] metadata
    #
    def initialize(file_path, workspace, metadata={})
      @file_path = file_path
      @workspace = workspace
      @metadata  = metadata
    end

    #
    # Create GeoTIFF.
    #
    module GeotiffLoader

      attr_reader :geotiff

      def initialize(*args)
        super
        @geotiff = Geoloader::Geotiff.new(@file_path, @workspace, @metadata)
      end

    end

    #
    # Create Shapefile.
    #
    module ShapefileLoader

      attr_reader :shapefile

      def initialize(*args)
        super
        @shapefile = Geoloader::Shapefile.new(@file_path, @workspace, @metadata)
      end

    end

    #
    # Connect to Geoserver.
    #
    module GeoserverLoader

      attr_reader :geoserver

      def initialize(*args)
        super
        @geoserver = Geoloader::Geoserver.new
        @geoserver.ensure_workspace(@workspace)
      end

    end

    #
    # Connect to Solr.
    #
    module SolrLoader

      attr_reader :solr

      def initialize(*args)
        super
        @solr = Geoloader::Solr.new
      end

    end

  end

end
