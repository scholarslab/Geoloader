
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'fileutils'
require 'pg'

module Geoloader
  class Postgis

    #
    # List all databases.
    #
    def list_databases
      # TODO
      puts "list dbs"
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
