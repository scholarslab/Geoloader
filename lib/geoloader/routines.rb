
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'resque'

module Geoloader
  module Routines

    #
    # Load an individual GeoTIFF.
    #
    # @param [String] file_path
    #
    def load_geotiff(file_path)
      Geoloader::GeotiffLoader.new(file_path, "geoloader").load
    end

    #
    # Load an individual Shapefile.
    #
    # @param [String] file_path
    #
    def load_shapefile(file_path)
      Geoloader::ShapefileLoader.new(file_path, "geoloader").load
    end

    #
    # Count assets by workspace.
    #
    def count_assets
      Geoloader::Solr.new.get_workspace_counts
    end

    #
    # Delete all Geoserver stores and Solr documents in a workspace.
    #
    def clear_workspace(workspace)
      Geoloader::Geoserver.new.delete_workspace(workspace) rescue nil
      Geoloader::Solr.new.delete_by_workspace(workspace) rescue nil
    end

    #
    # Start a Resque worker.
    #
    def start_worker
      Resque::Worker.new("geoloader").work
    end

  end
end
