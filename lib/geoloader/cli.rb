
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "terminal-table"
require "thor"

module Geoloader
  class CLI < Thor

    include Tasks

    desc "load [FILES]", "Load GeoTIFFs and Shapefiles to Geoserver, Geonetwork, and Solr"
    option :services,   :aliases => "-s", :type => :array
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

      # Load or enqueue the files.
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

    desc "work", "Start a Resque worker"
    def work
      Resque::Worker.new("geoloader").work
    end

  end
end
