
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'fileutils'
require 'pg'

module Geoloader
  class Postgres

    #
    # List all databases.
    #
    def list_databases
      connect
      @pg.exec("SELECT datname FROM pg_database") do |table|
        puts table
      end
      disconnect
    end

    #
    # Get a generic PostgreSQL connection instance.
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
    # Close the PostgreSQL connection.
    #
    def disconnect
      @pg.close
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

  end
end
