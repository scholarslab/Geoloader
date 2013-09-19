
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'rest_client'
require 'builder'

module Geoloader
  class Geonetwork

    # Set connection parameters.
    # @param [OrderedHash] config
    # @param [String] config :url
    # @param [String] config :username
    # @param [String] config :password
    # @param [Int] config :group
    def initialize config = {}
      @config = config
      @resource = RestClient::Resource.new(
        @config[:url],
        @config[:username],
        @config[:password]
      )
    end

    # XML services GET.
    # @param [String] service
    def get service
      @resource[service].get
    end

    # XML services POST.
    # @param [String] service
    # @param [String] payload
    # @param [Boolean] login
    def post service, payload
      puts payload
      @resource[service].post(payload, :content_type => :xml) { |resp, req, res, &b|
        if [301, 302, 307].include? resp.code
          resp.follow_redirection req, res, &b
        else
          resp.return! req, res, &b
        end
      }
    end

    # Insert a new record.
    # @param [String] metadata
    def insert metadata
      post "metadata.insert", self.class.xml.request { |r|

        # Configuration.
        r.group @config[:group]
        r.category "_none_"
        r.styleSheet "_none_"

        # Record metadata.
        r.data { |d| d.cdata! metadata }

      }
    end

    # Get an XML builder.
    def self.xml
      xml = Builder::XmlMarkup.new
      xml.instruct! :xml, :version => "1.0", :encoding => "UTF-8"
      xml
    end

  end
end
