
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'fileutils'
require 'pg'

module Geoloader
  class Shapefile < Asset

    attr_reader :sql_path

    # Convert the file to SQL for PostGIS.
    def generate_sql
      @sql_path = "#{Geoloader.config.directory}/#{@base_name}.geoloader.sql"
      system "shp2pgsql #{@file_path} > #{@sql_path}"
    end

    # Create a PostGIS database for a shapefile.
    #
    # @param [Geoloader::Shapefile] shapefile
    def create_database shapefile
      system "createdb #{@base_name}"
      system "psql -d #{@base_name} -c 'CREATE EXTENSION postgis;'"
    end

    # Source shapefile SQL to the new database.
    #
    # @param [Geoloader::Shapefile] shapefile
    def source_sql shapefile
      system "psql -d #{@base_name} -f #{@sql_path}"
    end

    # TODO|dev
    # Fetch a list of layers in the database.
    #
    # @param [Geoloader::Shapefile] shapefile
    def get_layers shapefile
      conn = PG.connect dbname: @base_name
      conn.exec "SELECT f_table_name FROM geometry_columns"
    end

  end
end
