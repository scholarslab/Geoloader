
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  module Loaders
    module Geoserver

      attr_reader :geoserver

      def initialize(*args)
        super
        @geoserver = Geoloader::Services::Geoserver.new
        @geoserver.ensure_workspace(@workspace)
      end

    end
  end
end
