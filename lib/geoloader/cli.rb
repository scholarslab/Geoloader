
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "terminal-table"
require "thor"

module Geoloader
  module CLI


    module Tasks

      #
      # Perform on enqueue an upload.
      #
      # @param [Class] loader
      # @param [String] file_name
      # @param [String] workspace
      # @param [Boolean] queue
      #
      def load_or_enqueue(loader, file_path, workspace, queue = false)
        if queue
          Resque.enqueue(loader, file_path, workspace)
        else
          loader.perform(file_path, workspace)
        end
      end

      #
      # Push a GeoTIFF to Geoserver.
      #
      # @param [String] file_name
      # @param [String] workspace
      # @param [Boolean] queue
      #
      def load_geotiff_geoserver(file_path, workspace, queue)
        load_or_enqueue(Geoloader::Loaders::GeotiffGeoserver, file_path, workspace, queue)
      end

      #
      # Push a GeoTIFF to Solr.
      #
      # @param [String] file_name
      # @param [String] workspace
      # @param [Boolean] queue
      #
      def load_geotiff_solr(file_path, workspace, queue)
        load_or_enqueue(Geoloader::Loaders::GeotiffSolr, file_path, workspace, queue)
      end

      #
      # Push a Shapefile to Geoserver.
      #
      # @param [String] file_name
      # @param [String] workspace
      # @param [Boolean] queue
      #
      def load_shapefile_geoserver(file_path, workspace, queue)
        load_or_enqueue(Geoloader::Loaders::ShapefileGeoserver, file_path, workspace, queue)
      end

      #
      # Push a Shapefile to Solr.
      #
      # @param [String] file_name
      # @param [String] workspace
      # @param [Boolean] queue
      #
      def load_shapefile_solr(file_path, workspace, queue)
        load_or_enqueue(Geoloader::Loaders::ShapefileSolr, file_path, workspace, queue)
      end

      #
      # Push an asset to Geonetwork.
      #
      # @param [String] file_name
      # @param [String] workspace
      # @param [Boolean] queue
      #
      def load_geonetwork(file_path, workspace, queue)
        load_or_enqueue(Geoloader::Loaders::Geonetwork, file_path, workspace, queue)
      end

      #
      # Delete all stores from a Geoserver workspace.
      #
      # @param [String] workspace
      #
      def clear_geoserver(workspace)
        Geoloader::Services::Geoserver.new.delete_workspace(workspace)
      end

      #
      # Delete all stores from a Geonetwork group.
      #
      # @param [String] workspace
      #
      def clear_geonetwork(workspace)
        Geoloader::Services::Geonetwork.new.delete_records_by_group(workspace)
      end

      #
      # Delete all Solr documents in a workspace.
      #
      # @param [String] workspace
      #
      def clear_solr(workspace)
        Geoloader::Services::Solr.new.delete_by_workspace(workspace)
      end

    end


    class Solr < Thor

      include Tasks

      desc "load [FILES]", "Load Solr documents"
      option :queue,      :aliases => "-q", :type => :boolean, :default => false
      option :workspace,  :aliases => "-w", :type => :string
      def load(*files)

        # If no workspace passed, use the default.
        @workspace = options[:workspace] or Geoloader.config.workspaces.production

        files.each { |file_path|
          case File.extname(file_path)
          when ".tif" # GEOTIFF
            load_geotiff_solr(file_path, @workspace, options[:queue])
          when ".shp" # SHAPEFILE
            load_shapefile_solr(file_path, @workspace, options[:queue])
          end
        }

      end

      desc "clear [WORKSPACE]", "Clear all documents in a workspace"
      def clear(workspace)
        clear_solr(workspace) rescue nil
      end

    end


    class Geoserver < Thor

      include Tasks

      desc "load [FILES]", "Load Geoserver stores and layers"
      option :queue,      :aliases => "-q", :type => :boolean, :default => false
      option :workspace,  :aliases => "-w", :type => :string
      def load(*files)

        # If no workspace passed, use the default.
        @workspace = options[:workspace] or Geoloader.config.workspaces.production

        files.each { |file_path|
          case File.extname(file_path)
          when ".tif" # GEOTIFF
            load_geotiff_geoserver(file_path, @workspace, options[:queue])
          when ".shp" # SHAPEFILE
            load_shapefile_geoserver(file_path, @workspace, options[:queue])
          end
        }

      end

      desc "clear [WORKSPACE]", "Clear all documents in a workspace"
      def clear(workspace)
        clear_geoserver(workspace) rescue nil
      end

    end


    class Geonetwork < Thor

      include Tasks

      desc "load [FILES]", "Load Geonetwork metadata records"
      option :queue,      :aliases => "-q", :type => :boolean, :default => false
      option :workspace,  :aliases => "-w", :type => :string
      def load(*files)

        # If no workspace passed, use the default.
        @workspace = options[:workspace] or Geoloader.config.workspaces.production

        files.each { |file_path|
          load_geonetwork(file_path, @workspace, options[:queue])
        }

      end

      desc "clear [WORKSPACE]", "Clear all records in a group"
      def clear(workspace)
        clear_geonetwork(workspace) rescue nil
      end

    end


    class App < Thor

      desc "solr [SUBCOMMAND]", "Manage Solr documents"
      subcommand "solr", Solr

      desc "geoserver [SUBCOMMAND]", "Manage Geoserver stores and layers"
      subcommand "geoserver", Geoserver

      desc "geonetwork [SUBCOMMAND]", "Manage Geonetwork records"
      subcommand "geonetwork", Geonetwork

      desc "work", "Start a Resque worker"
      def work
        Resque::Worker.new("geoloader").work
      end

    end


  end
end
