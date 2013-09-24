
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'fileutils'

module Geoloader
  class Postgis

    # Source shapefile SQL.
    #
    # @param [Geoloader::Shapefile] shapefile
    def add_table shapefile
      system "psql -d #{Geoloader.config.postgis.database} -f #{shapfile.sql_path}"
    end

  end
end
