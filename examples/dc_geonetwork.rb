
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'geoloader'

geonetwork = Geoloader::Geonetwork.new({
  :url        => "http://localhost:8080/geonetwork/srv/en",
  :username   => "admin",
  :password   => "admin",
  :group      => 2
})

metadata = <<eot
<simpledc xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dct="http://purl.org/dc/terms/">
  <dc:title>Geoloader 3</dc:title>
  <dc:creator>David McClure</dc:creator>
</simpledc>
eot

response = geonetwork.metadata_insert metadata
puts response.code
