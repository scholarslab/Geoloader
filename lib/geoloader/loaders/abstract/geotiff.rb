
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  module Loaders
    module Abstract
      module Geotiff

        attr_reader :geotiff

        def initialize(*args)
          super
          @geotiff = Geoloader::Assets::Geotiff.new(@file_path, @workspace)
        end

      end
    end
  end
end
