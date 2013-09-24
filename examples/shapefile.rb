
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'geoloader'

Geoloader.configure_from_yaml "../config/testing.yaml"
postgis = Geoloader::Postgis.new

# Source to Postgis.
shapefile = Geoloader::Shapefile.new ARGV[0]
postgis.add_table shapefile
