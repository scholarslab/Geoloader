
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'geoloader'

Geoloader.configure_from_yaml "../config/testing.yaml"

# Generate SQL.
shp = Geoloader::Shapefile.new ARGV[0]
shp.generate_sql

# Source to Postgis.
postgis = Geoloader::Postgis.new
postgis.add_table shp
