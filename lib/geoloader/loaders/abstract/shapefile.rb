
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  module Loaders
    module Shapefile

      attr_reader :shapefile

      def initialize(*args)
        super
        @shapefile = Geoloader::Assets::Shapefile.new(@file_path, @workspace)
      end

    end
  end
end
