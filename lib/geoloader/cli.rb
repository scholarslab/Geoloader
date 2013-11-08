
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "terminal-table"
require "thor"

module Geoloader
  class CLI < Thor

    desc "load [FILE]", "Load a YAML batch manifest"
    option :workspace, :type => :string, :aliases => "-w"
    def load(file_path)

      workspace = (options[:workspace] or Geoloader.config.workspace)

      case File.extname(file_path)
      when ".tif"
        Geoloader::GeoserverGeotiffLoader.new(file_path, workspace).load
        Geoloader::SolrGeotiffLoader.new(file_path, workspace).load

      when ".shp"
        Geoloader::GeoserverShapefileLoader.new(file_path, workspace).load
        Geoloader::SolrShapefileLoader.new(file_path, workspace).load
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

      # Delete Geoserver stores.
      Geoloader::Geoserver.new.delete_workspace(workspace) rescue nil

      # Delete Solr documents.
      Geoloader::Solr.new.delete_by_workspace(workspace) rescue nil

    end

    desc "work", "Start a Resque worker"
    def work
      Resque::Worker.new("geoloader").work
    end

  end
end
