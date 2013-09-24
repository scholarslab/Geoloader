
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'geoloader'

Geoloader.configure_from_yaml "../config/testing.yaml"

# Push to GeoServer.
geoserver = Geoloader::Geoserver.new
geotiff = Geoloader::Geotiff.new ARGV[0]
geoserver.upload_geotiff geotiff
