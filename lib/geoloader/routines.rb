
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "terminal-table"
require "resque"

module Geoloader
  module Routines

    #
    # Load a batch manifest.
    #
    # @param [String] manifest
    # @param [Boolean] resque
    #
    def self.load(file_path, resque)

      # Read the manifest.
      manifest_path = File.expand_path(file_path)
      manifest = YAML::load(File.read(manifest_path))

      # For each matched file in the manifest:
      Dir.glob("#{File.dirname(manifest_path)}/#{manifest["files"]}") do |f|

        # Get a loader class.
        loader = case File.extname(f)
        when ".shp" then
          Geoloader::ShapefileLoader
        when ".tif"
          Geoloader::GeotiffLoader
        else
          next
        end

        # Perform or enqueue the load.
        if resque
          Resque.enqueue(loader, f, manifest)
        else
          loader.new(f, manifest).load
        end

      end

    end

    #
    # Clear all assets in a workspace.
    #
    # @param [String] workspace
    #
    def self.clear(workspace)

      # Delete Geoserver stores.
      Geoloader::Geoserver.new.delete_workspace(workspace)

      # Drop PostGIS tables.
      Geoloader::Postgres.new.drop_databases_by_workspace(workspace)

      # Delete Solr documents.
      Geoloader::Solr.new.delete_by_workspace(workspace)

    end

    #
    # List all workspaces with asset counts.
    #
    def self.list

      # Query for workspace counts. 
      counts = Geoloader::Solr.new.get_workspace_counts

      # Render  the table.
      Terminal::Table.new(
        :title    => "GEOLOADER",
        :headings => ["Workspace", "# Assets"],
        :rows     => counts
      )

    end

    #
    # Spin up a Resque worker.
    #
    def self.work
      Resque::Worker.new("geoloader").work
    end

  end
end
