
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'pg'

module Geoloader
  module Database

    #
    # Connect to the default database.
    #
    def initialize
      connect
    end

    #
    # Connect to Postgres.
    #
    # @param [String] name
    #
    def connect(database = "postgres")
      @pg = PG.connect(
        :host => Geoloader.config.postgis.host,
        :port => Geoloader.config.postgis.port,
        :user => Geoloader.config.postgis.username,
        :dbname => database
      )
    end

    #
    # Drop a database.
    #
    # @param [String] database
    #
    def create_database(database)
      @pg.exec("CREATE DATABASE #{PG::Connection.quote_ident(database)}")
    end

    #
    # Enable the PostGIS extension.
    #
    def enable_postgis(database)
      @pg.exec("CREATE EXTENSION postgis")
    end

    #
    # Drop a database.
    #
    # @param [String] database
    #
    def drop_database(database)
      @pg.exec("DROP DATABASE #{PG::Connection.quote_ident(database)}")
    end

    #
    # List all databases.
    #
    def list_databases
      get_column("pg_database", "datname")
    end

    #
    # Get an array of all column values in a table.
    #
    # @param [String] table
    # @param [String] column
    #
    def get_column(table, column)
      @pg.exec("SELECT * FROM #{table}").field_values(column)
    end

    #
    # Close the PostgreSQL connection.
    #
    def disconnect
      @pg.close
    end

  end
end
