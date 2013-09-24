
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'fileutils'

module Geoloader
  class Shapefile < Asset

    attr_reader :sql_path

    def generate_sql
      @sql_path = "#{Geoloader.config.directory}/#{@base_name}.sql"
      system "shp2pgsql #{@file_path} > #{@sql_path}"
    end

  end
end
