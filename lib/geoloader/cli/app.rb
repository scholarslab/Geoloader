
require "thor"

module Geoloader
  module CLI

    class App < Thor

      desc "solr [SUBCOMMAND]", "Manage Solr documents"
      subcommand "solr", Solr

      desc "geoserver [SUBCOMMAND]", "Manage Geoserver stores and layers"
      subcommand "geoserver", Geoserver

      desc "geonetwork [SUBCOMMAND]", "Manage Geonetwork records"
      subcommand "geonetwork", Geonetwork

      desc "work", "Start a Resque worker"
      def work
        Resque::Worker.new("geoloader").work
      end

    end

  end
end
