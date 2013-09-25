
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'fileutils'

module Geoloader
  class Shapefile < Asset

    attr_reader :sql_path

    # Convert the file to SQL for PostGIS.
    def generate_sql
      @sql_path = "#{Geoloader.config.assets.pending}/#{@base_name}.geoloader.sql"
      system "shp2pgsql #{@file_path} > #{@sql_path}"
    end

    # Prepare the file for PostGIS.
    def process
      generate_sql
      super
    end

  end
end
