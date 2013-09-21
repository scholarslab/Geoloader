
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'rest_client'
require 'builder'

module Geoloader
  class Geonetwork

    # Set connection parameters.
    #
    # @param [OrderedHash] config
    # @param [String] config :url
    # @param [String] config :username
    # @param [String] config :password
    # @param [Int] config :group
    def initialize config = {}
      @config = config
      @resource = RestClient::Resource.new @config[:url], {
        :user     => @config[:username],
        :password => @config[:password],
        :headers  => { :content_type => :xml }
      }
    end

    # POST to an XML service.
    #
    # @param [String] service
    # @param [String] payload
    # @return [RestClient::Response]
    def post service, payload
      @resource[service].post(payload) { |resp, req, res, &b|
        if [301, 302, 307].include? resp.code
          resp.follow_redirection req, res, &b
        else
          resp.return! req, res, &b
        end
      }
    end

    # Insert a new record.
    #
    # @param [String] path
    # @param [String] style_sheet
    # @param [String] category
    # @return [RestClient::Response]
    def metadata_insert path, style_sheet = "_none_", category = "_none_"
      post "metadata.insert", self.class.xml.request { |r|
        r.group @config[:group]
        r.data { |d| d.cdata! File.read(path) }
        r.category category
        r.styleSheet style_sheet
      }
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
