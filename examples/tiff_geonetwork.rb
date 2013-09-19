
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'rest_client'
require 'builder'

geonetwork = RestClient::Resource.new "http://localhost:8080/geonetwork/srv/en"

builder = Builder::XmlMarkup.new(:indent => 2)
builder.instruct! :xml, :version => "1.0", :encoding => "UTF-8"

q = builder.request { |r|
  r.any "africa"
}

test = geonetwork["xml.search"].post(q, :content_type => :xml) { |resp, req, res, &b|
  if [301, 302, 307].include? resp.code
    resp.follow_redirection(req, res, &b)
  else
    resp.return!(req, res, &b)
  end
}

puts test.body
