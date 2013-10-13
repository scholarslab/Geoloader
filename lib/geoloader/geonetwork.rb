
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'rest_client'
require 'builder'
require 'nokogiri'

module Geoloader
  class Geonetwork

    attr_reader :resource

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
    # @param  [String] service
    # @param  [String] payload
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

    # List all groups on the node.
    #
    # @return [RestClient::Response]
    def list_groups
      @resource["xml.group.list"].get
    end

    # Get a group by name.
    #
    # @param  [String] name
    # @return [RestClient::Response]
    def get_group(name)
      Nokogiri::XML(list_groups).at_xpath("//record[name[text()='#{name}']]")
    end

    # Insert a new record.
    #
    # @param  [Geoloader::Asset] asset
    # @param  [String] style_sheet
    # @param  [String] category
    # @return [RestClient::Response]
    def create_record(asset, style_sheet = "_none_", category = "_none_")
      post("metadata.insert", self.class.xml_doc.request { |r|
        r.group @config.group
        r.data { |d| d.cdata! asset.get_xml }
        r.category category
        r.styleSheet style_sheet
      })
    end

    # Get an XML builder instance.
    #
    # @return [Builder::XmlMarkup]
    def self.xml_doc
      xml = Builder::XmlMarkup.new
      xml.instruct! :xml, :version => "1.0", :encoding => "UTF-8"
      xml
    end

  end
end
