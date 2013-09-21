
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'geoloader'

geonetwork = Geoloader::Geonetwork.new({
  :url        => "http://localhost:8080/geonetwork/srv/en",
  :username   => "admin",
  :password   => "admin",
  :group      => 2
})

response = geonetwork.metadata_insert ARGV[0]
puts response.code
