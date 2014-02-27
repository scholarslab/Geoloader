
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  module Loaders
    module Abstract
      module Solr

        attr_reader :solr

        def initialize(*args)
          super
          @solr = Geoloader::Services::Solr.new
        end

      end
    end
  end
end
