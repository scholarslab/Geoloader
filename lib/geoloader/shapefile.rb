
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "zip"

module Geoloader
  class Shapefile < Asset

    #
    # Zip up the Shapefile and its companion files.
    #
    def create_zipfile

      # Get the file path, minus the extension.
      path = "#{File.dirname(@file_path)}/#{@base_name}"

      # Create the zipfile.
      Zip::File.open("#{path}.zip") do |zipfile|
        Dir.glob("#{path}.*") do |file|
          zipfile.add(File.basename(file, ".*"), file)
        end
      end

    end

  end
end
