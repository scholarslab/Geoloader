
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "terminal-table"
require "thor"

module Geoloader
  module CLI

    class Geonetwork < Thor

      desc "load [FILES]", "Load files to Geonetwork"
      def load
        puts "geonetwork load"
      end

    end

  end
end
