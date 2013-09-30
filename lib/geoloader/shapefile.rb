
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'fileutils'
require 'pg'

module Geoloader
  class Shapefile < Asset

    attr_reader :sql_path

    # Convert the file to SQL for PostGIS.
    def generate_sql
      @sql_path = "#{File.dirname(@file_path)}/#{@base_name}.geoloader.sql"
      system "shp2pgsql #{@file_path} > #{@sql_path}"
    end

    # Create a PostGIS database for a shapefile.
    def create_database
      system "createdb #{@base_name}"
      system "psql #{self.psql_options} -d #{@base_name} -c 'CREATE EXTENSION postgis;'"
    end

    # Source shapefile SQL to the new database.
    def source_sql
      system "psql #{self.psql_options} -d #{@base_name} -f #{@sql_path}"
    end

    # Fetch a list of layers in the database.
    #
    # @return [PG::Result]
    def get_layers
      get_connection.exec("SELECT * FROM geometry_columns").field_values("f_table_name")
    end

    # Get a generic PostgreSQL connection instance.
    def get_connection
      PG.connect(
        :host => Geoloader.config.postgis.host,
        :port => Geoloader.config.postgis.port,
        :user => Geoloader.config.postgis.username,
        :dbname => @base_name
      )
    end

    # Form generic PostgreSQL connection parameters.
    def self.psql_options
      [
        "-h #{Geoloader.config.postgis.host}",
        "-p #{Geoloader.config.postgis.port}",
        "-U #{Geoloader.config.postgis.username}"
      ].join(" ")
    end

  end
end
