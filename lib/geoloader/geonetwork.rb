
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'rest_client'
require 'builder'
require 'nokogiri'

module Geoloader
  class Geonetwork

    attr_reader :resource

    # Create the Geonetwork resource.
    def initialize

      # Alias config, create resource.
      @config = Geoloader.config.geonetwork
      @resource = RestClient::Resource.new(@config.url, {
        :user     => @config.username,
        :password => @config.password,
        :headers  => { :content_type => :xml }
      })

      # If necessary, create the group.
      if not group_exists?(@config.group)
        create_group(@config.group)
      end

      # Cache the group id.
      @group_id = get_group_id(@config.group)

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

    # Get a group with a given name.
    #
    # @param  [String] name
    # @return [Nokogiri::XML]
    def get_group(name)
      Nokogiri::XML(list_groups).at_xpath("//record[name[text()='#{name}']]")
    end

    # Does a group with a given name exist?
    #
    # @param  [String] name
    # @return [Boolean]
    def group_exists?(name)
      !!get_group(name)
    end

    # Get the id of a group with a given name.
    #
    # @param  [String] name
    # @return [Integer]
    def get_group_id(name)
      get_group(name).at_xpath("id").content.to_i
    end

    # Create a new group with a given name.
    #
    # @param  [String] name
    # @return [RestClient::Response]
    def create_group(name)
      post("group.update", self.class.xml_doc.request { |r|
        r.name name
      })
    end

    # Delete group with a given name.
    #
    # @param  [String] name
    # @return [RestClient::Response]
    def delete_group(name)
      delete_records_by_group(name)
      post("group.remove", self.class.xml_doc.request { |r|
        r.id get_group_id(name)
      })
    end

    # Insert a new record.
    #
    # @param  [Geoloader::Asset] asset
    # @param  [String] style_sheet
    # @param  [String] category
    # @return [RestClient::Response]
    def create_record(asset, style_sheet = "_none_", category = "_none_")
      post("metadata.insert", self.class.xml_doc.request { |r|
        r.group @group_id
        r.data { |d| d.cdata! asset.get_xml }
        r.category category
        r.styleSheet style_sheet
      })
    end

    # Get all records in a given group.
    #
    # @param  [String] name
    # @return [RestClient::Response]
    def get_records_in_group(name)
      post("xml.search", self.class.xml_doc.request { |r|
        r.group get_group_id(name)
      })
    end

    # Count the number of records in a given group.
    #
    # @param  [String] name
    # @return [Integer]
    def count_records_in_group(name = @config.group)
      Nokogiri::XML(get_records_in_group(name)).at_xpath("//summary/@count").content.to_i
    end

    # Delete a record by id.
    #
    # @param  [Integer] id
    # @return [RestClient::Response]
    def delete_record_by_id(id)
      post("metadata.delete", self.class.xml_doc.request { |r|
        r.id id
      })
    end

    # Delete all records in a group with a given name.
    #
    # @param  [Integer] name
    # @return [RestClient::Response]
    def delete_records_by_group(name)
      Nokogiri::XML(get_records_in_group(name)).xpath("//metadata//id").each do |m|
        delete_record_by_id(m.content.to_i)
      end
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
