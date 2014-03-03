
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  module Loaders

    class Loader

      #
      # Perform an upload (used by Resque).
      #
      # @param [String] file_name
      # @param [String] workspace
      #
      def self.perform(file_path, workspace)
        new(file_path, workspace).load
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

    end

    module Asset

      attr_reader :asset

      #
      # Create a generic asset.
      #
      def initialize(*args)
        super
        @asset = Geoloader::Assets::Asset.new(@file_path, @workspace)
      end

    end

    module Geotiff

      attr_reader :geotiff

      #
      # Create a GeoTIFF.
      #
      def initialize(*args)
        super
        @geotiff = Geoloader::Assets::Geotiff.new(@file_path, @workspace)
      end

    end

    module Shapefile

      attr_reader :shapefile

      #
      # Create a Shapefile.
      #
      def initialize(*args)
        super
        @shapefile = Geoloader::Assets::Shapefile.new(@file_path, @workspace)
      end

    end

    module Solr

      attr_reader :solr

      #
      # Connect to Solr.
      #
      def initialize(*args)
        super
        @solr = Geoloader::Services::Solr.new
      end

    end

    module Geoserver

      attr_reader :geoserver

      #
      # Connect to Geoserver.
      #
      def initialize(*args)
        super
        @geoserver = Geoloader::Services::Geoserver.new
        @geoserver.ensure_workspace(@workspace)
      end

    end

    class Geonetwork < Loader

      include Asset

      attr_reader :geonetwork
      @queue = :geoloader

      #
      # Connect to Geonetwork.
      #
      def initialize(*args)
        super
        @geonetwork = Geoloader::Services::Geonetwork.new
        @geonetwork.ensure_group(@workspace)
      end

      #
      # Push an asset to Geonetwork.
      #
      def load
        @asset.stage do
          @geonetwork.create_record(@asset)
        end
      end

    end

    class GeotiffGeoserver < Loader

      include Geotiff
      include Geoserver

      @queue = :geoloader

      #
      # Push a GeoTIFF to Geoserver.
      #
      def load
        @geotiff.stage do

          # Prepare the file.
          @geotiff.make_borders_transparent
          @geotiff.project_to_4326

          # Push to Geoserver.
          @geoserver.create_coveragestore(@geotiff)

        end
      end

    end

    class GeotiffSolr < Loader

      include Geotiff
      include Solr

      @queue = :geoloader

      #
      # Push a GeoTIFF to Solr.
      #
      def load
        @geotiff.stage do
          @solr.create_document(@geotiff)
        end
      end

    end

    class ShapefileGeoserver < Loader

      include Shapefile
      include Geoserver

      @queue = :geoloader

      #
      # Push a Shapefile to Geoserver.
      #
      def load
        @shapefile.stage do
          @geoserver.create_datastore(@shapefile)
        end
      end

    end

    class ShapefileSolr < Loader

      include Shapefile
      include Solr

      @queue = :geoloader

      #
      # Push a Shapefile to Solr.
      #
      def load
        @shapefile.stage do
          @solr.create_document(@shapefile)
        end
      end

    end

  end
end
