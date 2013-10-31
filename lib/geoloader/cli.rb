
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "terminal-table"
require "thor"

module Geoloader
  class Application < Thor

    include Routines

    desc "load [FILE]", "Load a YAML batch manifest"
    def load(file_path)
      case File.extname(file_path)
      when ".tif"
        load_geotiff(file_path, "geoloader")
      when ".shp"
        load_shapefile(file_path, "geoloader")
      end
    end

    desc "list", "List workspaces and asset counts"
    def list
      puts Terminal::Table.new(
        :title    => "GEOLOADER",
        :headings => ["Workspace", "# Assets"],
        :rows     => count_assets
      )
    end

    desc "clear [WORKSPACE]", "Clear a workspace"
    def clear(workspace)
      clear_workspace(workspace)
    end

    desc "work", "Start a Resque worker"
    def work
      start_worker
    end

  end
end
