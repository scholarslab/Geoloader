
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
    def create_database
      system "createdb #{@base_name}"
      system "psql -d #{@base_name} -c 'CREATE EXTENSION postgis;'"
    end

    # Source shapefile SQL to the new database.
    def source_sql
      system "psql -d #{@base_name} -f #{@sql_path}"
    end

    # Fetch a list of layers in the database.
    #
    # @return [PG::Result]
    def get_layers
      conn = PG.connect dbname: @base_name
      cols = conn.exec "SELECT * FROM geometry_columns"
      cols.field_values "f_table_name"
    end

  end
end
