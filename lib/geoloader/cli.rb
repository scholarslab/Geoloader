
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "terminal-table"
require "thor"

module Geoloader
  module CLI

    class Solr < Thor

      include Tasks

      desc "load [FILES]", "Load files to Solr"
      option :workspace,  :aliases => "-w", :type => :string
      option :queue,      :aliases => "-q", :type => :boolean, :default => false
      option :metadata,   :aliases => "-m", :type => :string
      def load(*files)

        # If no workspace is defined, use the global default.
        workspace = (options[:workspace] or Geoloader.config.workspaces.production)

        # If provided, load the metadata YAML manifest.
        if options[:metadata]
          metadata = YAML::load(File.read(File.expand_path(options[:metadata])))
        else
          metadata = {}
        end

        # Load (or enqueue) the files.
        files.each { |file_path|
          case File.extname(file_path)
          when ".tif" # GEOTIFF
            load_geotiff_solr(file_path, workspace, metadata, options[:queue])
          when ".shp" # SHAPEFILE
            load_shapefile_solr(file_path, workspace, metadata, options[:queue])
          end
        }

      end

      desc "clear [WORKSPACE]", "Clear all documents in a workspace"
      def clear(workspace)
        clear_solr_workspace(workspace) rescue nil
      end

    end

    class Geoserver < Thor

      include Tasks

      desc "load [FILES]", "Load files to Geoserver"
      option :workspace,  :aliases => "-w", :type => :string
      option :queue,      :aliases => "-q", :type => :boolean, :default => false
      option :metadata,   :aliases => "-m", :type => :string
      def load(*files)

        # If no workspace is defined, use the global default.
        workspace = (options[:workspace] or Geoloader.config.workspaces.production)

        # If provided, load the metadata YAML manifest.
        if options[:metadata]
          metadata = YAML::load(File.read(File.expand_path(options[:metadata])))
        else
          metadata = {}
        end

        # Load (or enqueue) the files.
        files.each { |file_path|
          case File.extname(file_path)
          when ".tif" # GEOTIFF
            load_geotiff_geoserver(file_path, workspace, metadata, options[:queue])
          when ".shp" # SHAPEFILE
            load_shapefile_geoserver(file_path, workspace, metadata, options[:queue])
          end
        }

      end

      desc "clear [WORKSPACE]", "Clear a Geoserver workspace"
      def clear(workspace)
        clear_geoserver_workspace(workspace) rescue nil
      end

    end

    class Geonetwork < Thor

      include Tasks

      desc "load [FILES]", "Load files to Geonetwork"
      option :workspace,  :aliases => "-w", :type => :string
      option :queue,      :aliases => "-q", :type => :boolean, :default => false
      option :metadata,   :aliases => "-m", :type => :string
      def load(*files)

        # If no workspace is defined, use the global default.
        workspace = (options[:workspace] or Geoloader.config.workspaces.production)

        # If provided, load the metadata YAML manifest.
        if options[:metadata]
          metadata = YAML::load(File.read(File.expand_path(options[:metadata])))
        else
          metadata = {}
        end

        # Load (or enqueue) the files.
        files.each { |file_path|
          case File.extname(file_path)
          when ".tif" # GEOTIFF
            load_geotiff_geonetwork(file_path, workspace, metadata, options[:queue])
          when ".shp" # SHAPEFILE
            load_shapefile_geonetwork(file_path, workspace, metadata, options[:queue])
          end
        }

      end

      desc "clear [WORKSPACE]", "Clear a Geonetwork group"
      def clear(workspace)
        clear_geonetwork_group(workspace) rescue nil
      end

    end

    class App < Thor

      include Tasks

      @services = ["solr", "geoserver", "geonetwork"]

      desc "load [FILES]", "Load GeoTIFFs and Shapefiles to Geoserver, Geonetwork, and Solr"
      option :services,   :aliases => "-s", :type => :array, :default => @services
      option :workspace,  :aliases => "-w", :type => :string
      option :queue,      :aliases => "-q", :type => :boolean, :default => false
      option :metadata,   :aliases => "-m", :type => :string
      def load(*files)

        # If no workspace is defined, use the global default.
        workspace = (options[:workspace] or Geoloader.config.workspaces.production)

        # If provided, load the metadata YAML manifest.
        if options[:metadata]
          metadata = YAML::load(File.read(File.expand_path(options[:metadata])))
        else
          metadata = {}
        end

        files.each { |file_path|
          case File.extname(file_path)
          when ".tif" # GEOTIFF
            options[:services].each { |service|
              send("load_geotiff_#{service}", file_path, workspace, metadata, options[:queue])
            }
          when ".shp" # SHAPEFILE
            options[:services].each { |service|
              send("load_shapefile_#{service}", file_path, workspace, metadata, options[:queue])
            }
          end
        }

      end

      desc "clear [WORKSPACE]", "Clear a workspace"
      def clear(workspace)
        clear_solr_workspace(workspace) rescue nil
        clear_geoserver_workspace(workspace) rescue nil
        clear_geonetwork_group(workspace) rescue nil
      end

      desc "work", "Start a Resque worker"
      def work
        Resque::Worker.new("geoloader").work
      end

      desc "solr [SUBCOMMAND]", "Manage Solr documents"
      subcommand "solr", Solr

      desc "geoserver [SUBCOMMAND]", "Manage Geoserver stores and layers"
      subcommand "geoserver", Geoserver

      desc "geoserver [SUBCOMMAND]", "Manage Geonetwork records"
      subcommand "geonetwork", Geonetwork

    end

  end
end
