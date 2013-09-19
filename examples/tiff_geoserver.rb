
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'geoloader'

geoserver = Geoloader::Geoserver.new({
  :url => "http://admin:geoserver@localhost:8080/geoserver/rest",
  :username => "admin",
  :password => "geoserver",
  :workspace => "geoloader"
})

# Strip border and rebuild header.
tiff = Geoloader::Geotiff.new ARGV[0]
tiff.process

# Push to GeoServer.
geoserver.upload_geotiff tiff
