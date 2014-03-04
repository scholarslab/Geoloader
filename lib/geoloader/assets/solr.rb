
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  module Assets

    module Solr

      #
      # Get metadata for Solr document.
      #
      def solr_document
        {
          :LayerId => @slug,
          :WorkspaceName => @workspace,
          :Name => @file_base
        }
      end

    end

  end
end
