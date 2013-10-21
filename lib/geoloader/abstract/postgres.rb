
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'fileutils'
require 'pg'

module Geoloader
  module Postgres

    #
    # Connect to Postgres.
    #
    # @param [String] database
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
    # Get an array of all column values in a table.
    #
    # @param [String] table
    # @param [String] column
    #
    def get_column(table, column)
      @pg.exec("SELECT * FROM #{table}").field_values(column)
    end

    #
    # List all databases.
    #
    def list_databases
      get_column("pg_database", "datname")
    end

    #
    # Drop a database.
    #
    # @param [String] database
    #
    def drop_database(database)
      @pg.exec("DROP DATABASE IF EXISTS #{database}")
    end

    #
    # Close the PostgreSQL connection.
    #
    def disconnect
      @pg.close
    end

  end
end
