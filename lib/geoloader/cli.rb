
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "terminal-table"
require "thor"

module Geoloader
  class CLI < Thor

    include Tasks

    desc "load [FILE]", "Load a YAML batch manifest"
    option :workspace,  :aliases => "-w", :type => :string
    option :geoserver,  :aliases => "-g", :type => :boolean, :default => false
    option :solr,       :aliases => "-s", :type => :boolean, :default => false
    option :queue,      :aliases => "-q", :type => :boolean, :default => false
    def load(file_path)

      workspace = (options[:workspace] or Geoloader.config.workspace)

      case File.extname(file_path)

      when ".tif" # GEOTIFF

        if options[:geoserver]
          load_geotiff_geoserver(file_path, workspace, options[:queue])
        end

        if options[:solr]
          load_geotiff_solr(file_path, workspace, options[:queue])
        end

      when ".shp" # SHAPEFILE

        if options[:geoserver]
          load_shapefile_geoserver(file_path, workspace, options[:queue])
        end

        if options[:solr]
          load_shapefile_solr(file_path, workspace, options[:queue])
        end

      end

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
      clear_geoserver_workspace(workspace) rescue nil
      clear_solr_workspace(workspace) rescue nil
    end

    desc "work", "Start a Resque worker"
    def work
      Resque::Worker.new("geoloader").work
    end

  end
end
