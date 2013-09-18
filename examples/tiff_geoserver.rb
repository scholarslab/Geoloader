
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'geoloader'
require 'rest_client'

# Strip border and rebuild header.
tiff = Geoloader::Geotiff.new ARGV[0]
tiff.process

# Push to GeoServer.
geoserver = "http://admin:geoserver@localhost:8080/geoserver/rest"
coverages = "#{geoserver}/workspaces/geoloader/coveragestores/#{tiff.base}/file.geotiff"
RestClient.put coverages, File.read(tiff.path)
