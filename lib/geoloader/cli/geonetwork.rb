
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "terminal-table"
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

        # Get the active workspace.
        workspace = resolve_workspace(options[:workspace])

        files.each { |file_path|
          load_geonetwork(
            file_path, workspace, options[:description], options[:queue]
          )
        }

      end

      desc "clear [WORKSPACE]", "Clear all records in a group"
      def clear(workspace)
        clear_geonetwork(workspace) rescue nil
      end

    end

  end
end
