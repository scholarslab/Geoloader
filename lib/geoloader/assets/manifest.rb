
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "fileutils"
require "redcarpet"
require "nokogiri"

module Geoloader
  module Assets

    class Manifest

      attr_reader :title, :abstract

      #
      # Parse the markdown and extract the header.
      #
      # @param [String] file_path
      #
      def initialize(file_path = nil)

        @file_path = file_path

        if @file_path

          # Parse the markdown.
          markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
          document = Nokogiri::HTML::fragment(markdown.render(File.read(@file_path)))

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
