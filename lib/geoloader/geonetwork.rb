
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'rest_client'

module Geoloader
  class Geonetwork

    # Set connection parameters.
    # @param [OrderedHash] config
    # @param [String] config :url
    # @param [String] config :username
    # @param [String] config :password
    def initialize config = {}
      @config = config
      @resource = RestClient::Resource.new @config[:url]
    end

    # XML services GET.
    # @param [String] service
    def get service
      @resource[service].get
    end

    # XML services POST.
    # @param [String] service
    # @param [String] payload
    def post service, payload
      @resource[service].post(payload, :content_type => :xml) { |resp, req, res, &block|
        if [301, 302, 307].include? resp.code
          resp.follow_redirection req, res, &block
        else
          resp.return! req, res, &block
        end
      }
    end

  end
end
