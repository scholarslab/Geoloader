
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'geoloader'

Geoloader.configure_from_yaml "../config/testing.yaml"
shapefile = Geoloader::Shapefile.new ARGV[0]

# Source to Postgis.
postgis = Geoloader::Postgis.new
postgis.add_table shapefile

# Publish on Geoserver
geoserver = Geoloader::Geoserver.new
geoserver.publish_table shapefile
