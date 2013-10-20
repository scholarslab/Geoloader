
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'fileutils'
require 'pg'

module Geoloader
  class Shapefile < Asset

    #
    # Create a PostGIS-enabled database and connect to it.
    #
    def create_database
      system "createdb #{self.class.psql_options} #{@uuid}"
      system "psql #{self.class.psql_options} -d #{@uuid} -c 'CREATE EXTENSION postgis;'"
    end

    #
    # Convert the file to SQL for PostGIS.
    #
    def insert_tables
      sql_path = "#{File.dirname(@file_path)}/#{@base_name}.sql"
      system "shp2pgsql #{@file_path} > #{sql_path}"
      system "psql #{self.class.psql_options} -d #{@uuid} -f #{sql_path}"
    end

    #
    # Fetch a list of layers in the database.
    #
    def get_layers
      @pg.exec("SELECT * FROM geometry_columns").field_values("f_table_name")
    end

    #
    # Drop the PostGIS database.
    #
    def drop_database
      system "dropdb #{self.class.psql_options} #{@uuid}"
    end

    #
    # Get a generic PostgreSQL connection instance.
    #
    def connect
      @pg = PG.connect(
        :host => Geoloader.config.postgis.host,
        :port => Geoloader.config.postgis.port,
        :user => Geoloader.config.postgis.username,
        :dbname => @uuid
      )
    end

    #
    # Form generic PostgreSQL connection parameters.
    #
    def self.psql_options
      [
        "-h #{Geoloader.config.postgis.host}",
        "-p #{Geoloader.config.postgis.port}",
        "-U #{Geoloader.config.postgis.username}"
      ].join(" ")
    end

    #
    # Close the PostgreSQL connection.
    #
    def disconnect
      @pg.close
    end

  end
end
