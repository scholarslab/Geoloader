
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "pg"

module Geoloader
  class Shapefile < Asset

    include Database

    #
    # Connect to PostgreSQL.
    #
    def initialize(*args)
      super
      connect!
    end

    #
    # Create a new database.
    #
    def create_database!
      @pg.exec("CREATE DATABASE #{PG::Connection.quote_ident(@slug)}")
      connect!(@slug)
      @pg.exec("CREATE EXTENSION postgis")
    end

    #
    # Convert the file to SQL for PostGIS.
    #
    def insert_tables
      @pg.exec(`shp2pgsql #{@file_path}`)
    end

    #
    # Fetch a list of layers in the database.
    #
    def get_layers
      get_column("geometry_columns", "f_table_name")
    end

    #
    # When work is finished, disconnect from PostgreSQL.
    #
    def dequeue
      super
      disconnect!
    end

  end
end
