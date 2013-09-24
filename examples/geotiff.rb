
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'geoloader'

Geoloader.configure_from_yaml "../config/testing.yaml"
geoserver = Geoloader::Geoserver.new

# Push to GeoServer.
geotiff = Geoloader::Geotiff.new ARGV[0]
geoserver.add_geotiff geotiff
