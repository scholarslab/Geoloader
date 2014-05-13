
require "redcarpet"
require "jekyll"
require "nokogiri"
require "fileutils"
require "ostruct"

module Geoloader
  module Assets

    class Description

      attr_reader :title, :abstract, :metadata

      #
      # Parse the markdown and extract the header.
      #
      # @param [String] file_path
      #
      def initialize(file_path)

        @title, @abstract = "", ""
        @metadata = {}

        if file_path

          @file_path = File.expand_path(file_path)

          # Read the YAML front matter.
          convertible = OpenStruct.new.extend(Jekyll::Convertible)
          @metadata = convertible.read_yaml(File.dirname(@file_path), File.basename(@file_path))

          # Scrub the YAML out of the markdown.
          markdown = File.read(@file_path).sub(/---(.|\n)*---/, '')

          # Parse the cleaned markdown.
          renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
          document = Nokogiri::HTML::fragment(renderer.render(markdown))

          # Set the title.
          header = document.at_css('h1')
          @title = header.text
          header.remove

          # Set the abstract.
          @abstract = document.to_s.strip

        end

      end

    end

  end
end
