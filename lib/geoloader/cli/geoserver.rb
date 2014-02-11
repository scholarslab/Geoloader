
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "terminal-table"
require "thor"

module Geoloader
  module CLI

    class Geoserver < Thor

      desc "load [FILES]", "Load files to Geoserver"
      def load
        puts "geoserver load"
      end

    end

  end
end
