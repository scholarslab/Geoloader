
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "terminal-table"
require "thor"

module Geoloader
  module CLI

    class Solr < Thor

      include Tasks

      desc "load [FILES]", "Load Solr documents"
      option :queue,        :aliases => "-q", :type => :boolean, :default => false
      option :workspace,    :aliases => "-w", :type => :string
      def load(*files)

        # Get the active workspace.
        workspace = resolve_workspace(options[:workspace])

        files.each { |file_path|
          case File.extname(file_path)
          when ".tif" # GEOTIFF
            load_geotiff_solr(file_path, workspace, options[:queue])
          when ".shp" # SHAPEFILE
            load_shapefile_solr(file_path, workspace, options[:queue])
          end
        }

      end

      desc "clear [WORKSPACE]", "Clear all documents in a workspace"
      def clear(workspace)
        clear_solr(workspace) rescue nil
      end

    end

  end
end
