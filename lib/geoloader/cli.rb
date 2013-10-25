
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "terminal-table"
require "thor"

module Geoloader
  class CLI < Thor

    desc "load MANIFEST", "Load a YAML batch manifest"
    option "queue", :aliases => "q", :type => :boolean, :default => false
    def load(manifest)
      Geoloader::Routines.load(manifest, options[:resque])
    end

    desc "clear WORKSPACE", "Clear a workspace"
    def clear(workspace)
      Geoloader::Routines.clear(workspace)
    end

    desc "list", "List workspaces and asset counts"
    def list
      puts Geoloader::Routines.list
    end

    desc "work", "Start a Resque worker"
    def work
      Geoloader::Routines.work
    end

  end
end
