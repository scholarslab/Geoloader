
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  module Tasks

    #
    # Push a GeoTIFF to Geoserver.
    #
    # @param [String] file_name
    # @param [String] workspace
    #
    def load_geotiff_geoserver(file_path, workspace)
      Geoloader::GeotiffGeoserverLoader.new(file_path, workspace).load
    end

    #
    # Push a GeoTIFF to Solr.
    #
    # @param [String] file_name
    # @param [String] workspace
    #
    def load_geotiff_solr(file_path, workspace)
      Geoloader::GeotiffSolrLoader.new(file_path, workspace).load
    end

    #
    # Push a Shapefile to Geoserver.
    #
    # @param [String] file_name
    # @param [String] workspace
    #
    def load_shapefile_geoserver(file_path, workspace)
      Geoloader::ShapefileGeoserverLoader.new(file_path, workspace).load
    end

    #
    # Push a Shapefile to Solr.
    #
    # @param [String] file_name
    # @param [String] workspace
    #
    def load_shapefile_solr(file_path, workspace)
      Geoloader::ShapefileSolrLoader.new(file_path, workspace).load
    end

  end
end
