
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'geoloader'

geonetwork = Geoloader::Geonetwork.new

# Push to Geonetwork.
geonetwork.metadata_insert ARGV[0]
