
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "terminal-table"
require "thor"

module Geoloader
  module CLI

    class Geoserver < Thor

      include Tasks

      desc "load [FILES]", "Load Geoserver stores and layers"
      option :queue,        :aliases => "-q", :type => :boolean, :default => false
      option :description,  :aliases => "-d", :type => :string
      option :workspace,    :aliases => "-w", :type => :string
      def load(*files)

        # Get the active workspace.
        workspace = resolve_workspace(options[:workspace])

        files.each { |file_path|
          case File.extname(file_path)
          when ".tif" # GEOTIFF
            load_geotiff_geoserver(
              file_path,workspace, options[:description], options[:queue]
            )
          when ".shp" # SHAPEFILE
            load_shapefile_geoserver(
              file_path, workspace, options[:description], options[:queue]
            )
          end
        }

      end

      desc "clear [WORKSPACE]", "Clear all documents in a workspace"
      def clear(workspace)
        clear_geoserver(workspace) rescue nil
      end

    end

  end
end
