
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'fileutils'

module Geoloader
  class Postgis

    # Create a fresh database for a shapefile.
    #
    # @param [Geoloader::Shapefile] shapefile
    def create_database shapefile
      system "createdb #{shapefile.base_name}"
      system "psql -d #{shapefile.base_name} -c 'CREATE EXTENSION postgis;'"
    end

    # Source shapefile SQL.
    #
    # @param [Geoloader::Shapefile] shapefile
    def source_sql shapefile
      system "psql -d #{shapefile.base_name} -f #{shapefile.sql_path}"
    end

  end
end
