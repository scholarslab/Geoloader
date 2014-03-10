
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "thor"

module Geoloader
  module CLI

    class Geonetwork < Thor

      include Tasks

      desc "load [FILES]", "Load Geonetwork metadata records"
      option :queue,        :aliases => "-q", :type => :boolean, :default => false
      option :description,  :aliases => "-d", :type => :string
      option :workspace,    :aliases => "-w", :type => :string
      def load(*files)

        files.each { |file_path|
          Geoloader::Loaders::Geonetwork.load_or_enqueue(file_path, options)
        }

      end

      desc "publish [WORKSPACE]", "Publish all records in a group"
      def publish(workspace)
        Geoloader::Tasks::Geonetwork.publish(workspace)
      end

      desc "clear [WORKSPACE]", "Clear all records in a group"
      def clear(workspace)
        Geoloader::Tasks::Geonetwork.clear(workspace) rescue nil
      end

    end

  end
end
