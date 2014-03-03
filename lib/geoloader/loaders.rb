
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


    class Geonetwork < Loader

      attr_reader :asset, :geonetwork

      @queue = :geoloader

      #
      # Configure the asset, connect to Geonetwork.
      #
      def initialize(*args)

        super

        # Create and configure the asset.
        @asset = Geoloader::Assets::Asset.new(@file_path, @workspace)
        @asset.extend(Geoloader::Assets::Geonetwork)

        # Connect to Geonetwork, create the group.
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

      attr_reader :geotiff, :geoserver

      @queue = :geoloader

      #
      # Configure the asset, connect to Geoserver.
      #
      def initialize(*args)

        super

        # Create and configure the asset.
        @geotiff = Geoloader::Assets::Asset.new(@file_path, @workspace)
        @geotiff.extend(Geoloader::Assets::Geotiff)

        # Connect to Geoserver, create the workspace.
        @geoserver = Geoloader::Services::Geoserver.new
        @geoserver.ensure_workspace(@workspace)

      end

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

      attr_reader :geotiff, :solr

      @queue = :geoloader

      #
      # Configure the asset, connect to Solr.
      #
      def initialize(*args)

        super

        # Create and configure the asset.
        @geotiff = Geoloader::Assets::Asset.new(@file_path, @workspace)
        @geotiff.extend(Geoloader::Assets::Geotiff)
        @geotiff.extend(Geoloader::Assets::Solr)

        # Connect to Solr.
        @solr = Geoloader::Services::Solr.new

      end

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

      attr_reader :shapefile, :geoserver

      @queue = :geoloader

      #
      # Configure the asset, connect to Geoserver.
      #
      def initialize(*args)

        super

        # Create and configure the asset.
        @shapefile = Geoloader::Assets::Asset.new(@file_path, @workspace)
        @shapefile.extend(Geoloader::Assets::Shapefile)

        # Connect to Geoserver, create the workspace.
        @geoserver = Geoloader::Services::Geoserver.new
        @geoserver.ensure_workspace(@workspace)

      end

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

      attr_reader :shapefile, :solr

      @queue = :geoloader

      #
      # Configure the shapefile, connect to Solr.
      #
      def initialize(*args)

        super

        # Create and configure the asset.
        @shapefile = Geoloader::Assets::Asset.new(@file_path, @workspace)
        @shapefile.extend(Geoloader::Assets::Shapefile)
        @shapefile.extend(Geoloader::Assets::Solr)

        # Connect to Solr.
        @solr = Geoloader::Services::Solr.new

      end

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
