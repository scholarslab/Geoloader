
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "pg"

module Geoloader
  class Postgres

    include Database

    #
    # Connect to the default database.
    #
    def initialize
      connect!
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

  end
end
