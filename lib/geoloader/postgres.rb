
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "pg"

module Geoloader
  class Postgres

    attr_reader :pg

    #
    # Connect to the default database.
    #
    def initialize
      connect!
    end

    #
    # Connect to PostgreSQL.
    #
    # @param [String] database
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
      fetch_column("pg_database", "datname")
    end

    #
    # Get an array of all column values in a table.
    #
    # @param [String] table
    # @param [String] column
    #
    def fetch_column(table, column)
      @pg.exec("SELECT * FROM #{table}").field_values(column)
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
    # Drop all databases with a given workspace prefix.
    #
    # @param [String] workspace
    #
    def drop_databases_by_workspace(workspace)
      list_databases.each do |database|
        if database.start_with?(workspace)
          drop_database(database)
        end
      end
    end

    #
    # Close the PostgreSQL connection.
    #
    def disconnect!
      @pg.close
    end

  end
end
