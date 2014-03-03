
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  module Loaders
    module Abstract
      module Asset

        attr_reader :asset

        def initialize(*args)
          super
          @asset = Geoloader::Assets::Asset.new(@file_path, @workspace)
        end

      end
    end
  end
end
