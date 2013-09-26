
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'geoloader'

Geoloader.configure_from_yaml "../config.yaml"
loader = Geoloader::ShapefileLoader.new ARGV[0]
loader.work
