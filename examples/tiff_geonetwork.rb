
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'geoloader'
require 'rest_client'
require 'httparty'
require 'awesome_print'

#service_root = "http://localhost:8080/geonetwork/srv/en"

#login = <<eot
#<?xml version="1.0" encoding="UTF-8"?>
#<request>
  #<username>admin</username>
  #<password>admin</password>
#</request>
#eot

#response = HTTParty.post "#{service_root}/xml.user.login", :body => login, :headers => {
  #'Content-type' => 'application/xml'
#}

#puts response.body

geonetwork = RestClient::Resource.new "http://localhost:8080/geonetwork/srv/en"
response = geonetwork['xml.group.list'].get
puts response.body

#login = <<eot
#<?xml version="1.0" encoding="UTF-8"?>
#<request>
    #<username>admin</username>
    #<password>admin</password>
#</request>
#eot

# Authenticate the user.
#geonetwork['xml.user.login'].post(login, {:content_type => :xml}) { |response, request, result, &block|
  #if [301, 302, 307].include? response.code
    #response.follow_redirection(request, result, &block)
  #end
#}

#record = <<eot
#<?xml version="1.0" encoding="UTF-8"?>
#<request>
  #<group>2</group>
  #<category>_none_</category>
  #<styleSheet>_none_</styleSheet>
  #<data><![CDATA[
    #<simpledc xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dct="http://purl.org/dc/terms/">
      #<dc:title>Gravity's Rainbow 4</dc:title>
      #<dc:creator>David McClure</dc:creator>
    #</simpledc>]]>
  #</data>
#</request>
#eot

## Insert a new record.
#geonetwork['metadata.insert'].post(record) { |response, request, result, &block|
  #if [301, 302, 307].include? response.code
    #response.follow_redirection(request, result, &block)
  #end
#}
