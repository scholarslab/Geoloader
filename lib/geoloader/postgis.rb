
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'fileutils'

module Geoloader
  class Postgis

    # Create a new database and source shapefile SQL.
    #
    # @param [Geoloader::Shapefile] shapefile
    def add_table shapefile
      system "psql -d #{shapefile.base_name} -f #{shapefile.sql_path}"
    end

  end
end
