
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'rest_client'
require 'builder'

module Geoloader
  class Geonetwork

    # Create the Geonetwork resource.
    def initialize
      @config = Geoloader.config.geonetwork
      @resource = RestClient::Resource.new(@config.url, {
        :user     => @config.username,
        :password => @config.password,
        :headers  => { :content_type => :xml }
      })
    end

    # POST to an XML service.
    #
    # @param [String] service
    # @param [String] payload
    # @return [RestClient::Response]
    def post(service, payload)
      @resource[service].post(payload) { |response, request, result, &block|
        if [301, 302, 307].include?(response.code)
          response.follow_redirection(request, result, &block)
        else
          response.return!(request, result, &block)
        end
      }
    end

    # Insert a new record.
    #
    # @param [Geoloader::Asset] asset
    # @param [String] style_sheet
    # @param [String] category
    # @return [RestClient::Response]
    def add_record(asset, style_sheet = "_none_", category = "_none_")
      post("metadata.insert", self.class.xml.request { |r|
        r.group @config.group
        r.data { |d| d.cdata! asset.metadata }
        r.category category
        r.styleSheet style_sheet
      })
    end

    # Get an XML builder instance.
    # @return [Builder::XmlMarkup]
    def self.xml
      xml = Builder::XmlMarkup.new
      xml.instruct! :xml, :version => "1.0", :encoding => "UTF-8"
      xml
    end

  end
end
