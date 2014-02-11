
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "terminal-table"
require "thor"

module Geoloader
  module CLI

    class Geoloader < Thor

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

      desc "list", "List workspaces and asset counts"
      def list

        # Query for workspace counts.
        counts = Geoloader::Solr.new.get_workspace_counts

        # Render the table.
        puts Terminal::Table.new(
          :title    => "GEOLOADER",
          :headings => ["Workspace", "# Assets"],
          :rows     => counts
        )

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

      desc "solr [SUBCOMMAND]", "Manage Solr documents."
      subcommand "solr", Solr

      desc "geoserver [SUBCOMMAND]", "Manage Geoserver stores and layers"
      subcommand "geoserver", Geoserver

      desc "geonetwork [SUBCOMMAND]", "Manage Geonetwork records"
      subcommand "geonetwork", Geonetwork

    end

    class Solr < Thor

      desc "load [FILES]", "Load files to Solr"
      def load
        puts "solr load"
      end

    end

    class Geoserver < Thor

      desc "load [FILES]", "Load files to Geoserver"
      def load
        puts "geoserver load"
      end

    end

    class Geonetwork < Thor

      desc "load [FILES]", "Load files to Geonetwork"
      def load
        puts "geonetwork load"
      end

    end

  end
end
