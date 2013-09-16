
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'geoloader'

tiff = Geoloader::Geotiff.new 'datasets/raster/test.tif'
tiff.process
