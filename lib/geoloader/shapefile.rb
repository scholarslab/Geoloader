
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'fileutils'
require 'pg'

module Geoloader
  class Shapefile < Asset

    attr_reader :database

    #
    # Form the database name.
    #
    def initialize
      super
      @database = "#{@workspace}_#{@base_name}"
    end

    #
    # Create a PostGIS-enabled database and connect to it.
    #
    def create_database
      system "createdb #{self.class.psql_options} #{@database}"
      system "psql #{self.class.psql_options} -d #{@database} -c 'CREATE EXTENSION postgis;'"
    end

    #
    # Convert the file to SQL for PostGIS.
    #
    def insert_tables
      sql_path = "#{File.dirname(@file_path)}/#{@base_name}.sql"
      system "shp2pgsql #{@file_path} > #{sql_path}"
      system "psql #{self.class.psql_options} -d #{@database} -f #{sql_path}"
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
      system "dropdb #{self.class.psql_options} #{@database}"
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
    # Get a generic PostgreSQL connection instance.
    #
    def connect
      @pg = PG.connect(
        :host => Geoloader.config.postgis.host,
        :port => Geoloader.config.postgis.port,
        :user => Geoloader.config.postgis.username,
        :dbname => @database
      )
    end

    #
    # Close the PostgreSQL connection.
    #
    def disconnect
      @pg.close
    end

  end
end
