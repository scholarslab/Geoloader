
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  module Loaders
    module Abstract
      module Geonetwork

        attr_reader :geonetwork

        def initialize(*args)
          super
          @geonetwork = Geoloader::Services::Geonetwork.new
          @geonetwork.ensure_group(@workspace)
        end

      end
    end
  end
end
