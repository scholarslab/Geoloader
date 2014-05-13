
module Geoloader
  module Assets

    module Solr

      #
      # Get metadata for Solr document.
      #
      def solr_document
        {
          :LayerId          => @uuid,
          :LayerDisplayName => @description.title,
          :Abstract         => @description.abstract,
          :WorkspaceName    => @workspace,
          :Name             => @file_base
        }
      end

    end

  end
end
