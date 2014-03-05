
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "zip"

module Geoloader
  module Assets

    module Shapefile

      #
      # Zip up the Shapefile and its companion files.
      #
      def get_zipfile

        # Create the zipfile.
        Zip::File.open("#{@file_base}.zip", Zip::File::CREATE) do |zipfile|
          Dir.glob("#{@file_base}.*") do |file|
            zipfile.add(File.basename(file), file)
          end
        end

        File.read("#{@file_base}.zip")

      end

    end

  end
end
