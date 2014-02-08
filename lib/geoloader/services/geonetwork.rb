
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'rest_client'
require 'builder'
require 'nokogiri'

module Geoloader
  class Geonetwork

    attr_reader :resource

    #
    # Initialize the API wrapper.
    #
    def initialize
      @resource = RestClient::Resource.new(@config.url, {
        :user     => @Geoloader.config.geonetwork.username,
        :password => @Geoloader.config.geonetwork.password,
        :headers  => { :content_type => :xml }
      })
    end

    #
    # List all groups on the node.
    #
    def get_groups
      @resource["xml.group.list"].get
    end

    #
    # Get a group with a given name.
    #
    # @param [String] group
    #
    def get_group(group)
      Nokogiri::XML(get_groups).at_xpath("//record[name[text()='#{group}']]")
    end

    #
    # Does a group with a given name exist?
    #
    # @param [String] group
    #
    def group_exists?(group)
      !!get_group(group)
    end

    #
    # Get the id of a group with a given name.
    #
    # @param [String] group
    #
    def get_group_id(group)
      get_group(name).at_xpath("id").content.to_i
    end

    #
    # Create a new group with a given name.
    #
    # @param [String] group
    #
    def create_group(group)
      post("group.update", self.class.xml_doc.request { |r|
        r.name group
      })
    end

    #
    # Check to see if a group exists, and if not, create it.
    #
    # @param [String] group
    #
    def ensure_group(group)
      create_group(group) unless group_exists?(group)
    end

    #
    # Delete group with a given name.
    #
    # @param [String] group
    #
    def delete_group(group)
      delete_records_by_group(group)
      post("group.remove", self.class.xml_doc.request { |r|
        r.id get_group_id(group)
      })
    end

    #
    # Insert a new record.
    #
    # @param [Geoloader::Asset] asset
    # @param [String] style_sheet
    # @param [String] category
    #
    def create_record(asset, style_sheet = "_none_", category = "_none_")
      post("metadata.insert", self.class.xml_doc.request { |r|
        r.group get_group_id
        r.data { |d| d.cdata! asset.get_iso19139_xml }
        r.category category
        r.styleSheet style_sheet
      })
    end

    #
    # Get all records in a given group.
    #
    # @param [String] group
    #
    def get_records_in_group(group)
      post("xml.search", self.class.xml_doc.request { |r|
        r.group get_group_id(group)
      })
    end

    #
    # Count the number of records in a given group.
    #
    # @param [String] group
    #
    def count_records_in_group(group)
      Nokogiri::XML(get_records_in_group(group)).at_xpath("//summary/@count").content.to_i
    end

    #
    # Delete a record by id.
    #
    # @param [Integer] id
    #
    def delete_record_by_id(id)
      post("metadata.delete", self.class.xml_doc.request { |r|
        r.id id
      })
    end

    #
    # Delete all records in a group with a given name.
    #
    # @param [Integer] group
    #
    def delete_records_by_group(group)
      Nokogiri::XML(get_records_in_group(group)).xpath("//metadata//id").each do |m|
        delete_record_by_id(m.content.to_i)
      end
    end

    #
    # POST to an XML service.
    #
    # @param [String] service
    # @param [String] payload
    #
    def post(service, payload)
      @resource[service].post(payload) { |response, request, result, &block|
        if [301, 302, 307].include?(response.code)
          response.follow_redirection(request, result, &block)
        else
          response.return!(request, result, &block)
        end
      }
    end

    #
    # Get an XML builder instance.
    #
    def self.xml_doc
      xml = Builder::XmlMarkup.new
      xml.instruct! :xml, :version => "1.0", :encoding => "UTF-8"
      xml
    end

  end
end
