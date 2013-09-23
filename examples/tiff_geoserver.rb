
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'geoloader'

geoserver = Geoloader::Geoserver.new

# Strip border and add header.
tiff = Geoloader::Geotiff.new ARGV[0]
tiff.prepare

# Push to GeoServer.
geoserver.upload_geotiff tiff
