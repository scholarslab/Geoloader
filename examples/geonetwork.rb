
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'geoloader'

Geoloader.configure_from_yaml "../config/testing.yaml"

# Push to Geonetwork.
geonetwork = Geoloader::Geonetwork.new
geonetwork.metadata_insert ARGV[0]
