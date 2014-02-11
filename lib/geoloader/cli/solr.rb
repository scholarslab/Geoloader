
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "terminal-table"
require "thor"

module Geoloader
  module CLI

    class Solr < Thor

      desc "load [FILES]", "Load files to Solr"
      def load
        puts "solr load"
      end

    end

  end
end
