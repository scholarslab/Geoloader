
require "thor"

module Geoloader
  module CLI

    class Solr < Thor

      include Tasks

      desc "load [FILES]", "Load Solr documents"
      option :queue,        :aliases => "-q", :type => :boolean, :default => false
      option :description,  :aliases => "-d", :type => :string
      option :workspace,    :aliases => "-w", :type => :string
      def load(*files)

        files.each { |file_path|
          case File.extname(file_path)
          when ".tif" # GEOTIFF
            Geoloader::Loaders::GeotiffSolr.load_or_enqueue(file_path, options)
          when ".shp" # SHAPEFILE
            Geoloader::Loaders::ShapefileSolr.load_or_enqueue(file_path, options)
          end
        }

      end

      desc "clear [WORKSPACE]", "Clear all documents in a workspace"
      def clear(workspace)
        Geoloader::Tasks::Solr.clear(workspace) rescue nil
      end

    end

  end
end
