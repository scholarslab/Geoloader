
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "fileutils"

module Geoloader
  module Assets

    class Manifest

      #
      # Parse the markdown and extract the header.
      #
      # @param [String] file_path
      #
      def initialize(file_path)
        @file_path = file_path
        # TODO: Convert, parse.
      end

    end

  end
end
