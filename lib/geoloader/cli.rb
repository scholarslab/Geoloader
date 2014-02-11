
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "terminal-table"
require "thor"

module Geoloader
  module CLI

    class Service < Thor

      desc "load [FILES]", "Load files (abstract)"
      option :workspace,  :aliases => "-w", :type => :string
      option :queue,      :aliases => "-q", :type => :boolean, :default => false
      option :metadata,   :aliases => "-m", :type => :string
      def load(*files)

        # If no workspace is defined, use the default.
        @workspace = (options[:workspace] or Geoloader.config.workspaces.production)

        # If provided, load the metadata YAML manifest.
        if options[:metadata]
          @metadata = YAML::load(File.read(File.expand_path(options[:metadata])))
        else
          @metadata = {}
        end

      end

    end

    class Solr < Service

      include Tasks

      desc "load [FILES]", "Load Solr documents"
      def load(*files)
        super
        files.each { |file_path|
          case File.extname(file_path)
          when ".tif" # GEOTIFF
            load_geotiff_solr(file_path, @workspace, @metadata, options[:queue])
          when ".shp" # SHAPEFILE
            load_shapefile_solr(file_path, @workspace, @metadata, options[:queue])
          end
        }

      end

      desc "clear [WORKSPACE]", "Clear all documents in a workspace"
      def clear(workspace)
        clear_solr(workspace) rescue nil
      end

    end

    class Geoserver < Service

      include Tasks

      desc "load [FILES]", "Load Geoserver stores and layers"
      def load(*files)
        super
        files.each { |file_path|
          case File.extname(file_path)
          when ".tif" # GEOTIFF
            load_geotiff_geoserver(file_path, @workspace, @metadata, options[:queue])
          when ".shp" # SHAPEFILE
            load_shapefile_geoserver(file_path, @workspace, @metadata, options[:queue])
          end
        }
      end

      desc "clear [WORKSPACE]", "Clear all documents in a workspace"
      def clear(workspace)
        clear_geoserver(workspace) rescue nil
      end

    end

    class Geonetwork < Service

      include Tasks

      desc "load [FILES]", "Load Geonetwork metadata records"
      def load(*files)
        super
        files.each { |file_path|
          load_geonetwork(file_path, @workspace, @metadata, options[:queue])
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
