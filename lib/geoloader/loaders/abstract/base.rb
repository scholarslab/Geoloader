
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  module Loaders

    class Base

      #
      # Perform an upload (used by Resque).
      #
      # @param [String] file_name
      # @param [String] workspace
      #
      def self.perform(file_path, workspace)
        new(file_path, workspace, metadata).load
        puts "Loaded #{File.basename(file_path)}."
      end

      #
      # Set the file path and workspace.
      #
      # @param [String] file_name
      # @param [String] workspace
      #
      def initialize(file_path, workspace)
        @file_path = file_path
        @workspace = workspace
      end

      #
      # Create asset.
      #
      module Asset

        attr_reader :asset

        def initialize(*args)
          super
          @asset = Geoloader::Asset.new(@file_path, @workspace)
        end

      end

      #
      # Create GeoTIFF.
      #
      module Geotiff

        attr_reader :geotiff

        def initialize(*args)
          super
          @geotiff = Geoloader::Assets::Geotiff.new(@file_path, @workspace)
        end

      end

      #
      # Create Shapefile.
      #
      module Shapefile

        attr_reader :shapefile

        def initialize(*args)
          super
          @shapefile = Geoloader::Assets::Shapefile.new(@file_path, @workspace)
        end

      end

      #
      # Connect to Geoserver.
      #
      module Geoserver

        attr_reader :geoserver

        def initialize(*args)
          super
          @geoserver = Geoloader::Services::Geoserver.new
          @geoserver.ensure_workspace(@workspace)
        end

      end

      #
      # Connect to Geonetwork.
      #
      module Geonetwork

        attr_reader :geonetwork

        def initialize(*args)
          super
          @geonetwork = Geoloader::Services::Geonetwork.new
          @geonetwork.ensure_group(@workspace)
        end

      end

      #
      # Connect to Solr.
      #
      module Solr

        attr_reader :solr

        def initialize(*args)
          super
          @solr = Geoloader::Services::Solr.new
        end

      end

    end

  end
end
