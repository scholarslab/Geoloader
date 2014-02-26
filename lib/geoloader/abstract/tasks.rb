
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "resque"

module Geoloader
  module Tasks

    #
    # Perform on enqueue an upload.
    #
    # @param [Class] loader
    # @param [String] file_name
    # @param [String] workspace
    # @param [Boolean] queue
    #
    def load_or_enqueue(loader, file_path, workspace, queue = false)
      if queue
        Resque.enqueue(loader, file_path, workspace)
      else
        loader.perform(file_path, workspace)
      end
    end

    #
    # Push a GeoTIFF to Geoserver.
    #
    # @param [String] file_name
    # @param [String] workspace
    # @param [Boolean] queue
    #
    def load_geotiff_geoserver(file_path, workspace, queue)
      load_or_enqueue(Geoloader::GeotiffGeoserverLoader, file_path, workspace, queue)
    end

    #
    # Push a GeoTIFF to Solr.
    #
    # @param [String] file_name
    # @param [String] workspace
    # @param [Boolean] queue
    #
    def load_geotiff_solr(file_path, workspace, queue)
      load_or_enqueue(Geoloader::GeotiffSolrLoader, file_path, workspace, queue)
    end

    #
    # Push a Shapefile to Geoserver.
    #
    # @param [String] file_name
    # @param [String] workspace
    # @param [Boolean] queue
    #
    def load_shapefile_geoserver(file_path, workspace, queue)
      load_or_enqueue(Geoloader::ShapefileGeoserverLoader, file_path, workspace, queue)
    end

    #
    # Push a Shapefile to Solr.
    #
    # @param [String] file_name
    # @param [String] workspace
    # @param [Boolean] queue
    #
    def load_shapefile_solr(file_path, workspace, queue)
      load_or_enqueue(Geoloader::ShapefileSolrLoader, file_path, workspace, queue)
    end

    #
    # Push an asset to Geonetwork.
    #
    # @param [String] file_name
    # @param [String] workspace
    # @param [Boolean] queue
    #
    def load_geonetwork(file_path, workspace, queue)
      load_or_enqueue(Geoloader::GeonetworkLoader, file_path, workspace, metadata, queue)
    end

    #
    # Delete all stores from a Geoserver workspace.
    #
    # @param [String] workspace
    #
    def clear_geoserver(workspace)
      Geoloader::Geoserver.new.delete_workspace(workspace)
    end

    #
    # Delete all stores from a Geonetwork group.
    #
    # @param [String] workspace
    #
    def clear_geonetwork(workspace)
      Geoloader::Geonetwork.new.delete_records_by_group(workspace)
    end

    #
    # Delete all Solr documents in a workspace.
    #
    # @param [String] workspace
    #
    def clear_solr(workspace)
      Geoloader::Solr.new.delete_by_workspace(workspace)
    end

  end
end
