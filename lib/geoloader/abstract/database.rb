
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "pg"

module Geoloader
  module Database

    attr_accessor :pg

    #
    # Connect to PostgreSQL.
    #
    # @param [String] name
    #
    def connect!(database = "postgres")
      @pg = PG.connect(
        :host => Geoloader.config.postgres.host,
        :port => Geoloader.config.postgres.port,
        :user => Geoloader.config.postgres.username,
        :dbname => database
      )
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
    def disconnect!
      @pg.close
    end

  end
end
