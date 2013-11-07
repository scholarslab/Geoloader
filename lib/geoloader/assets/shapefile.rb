
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "zip"

module Geoloader
  class Shapefile < Asset

    #
    # Zip up the Shapefile and its companion files.
    #
    def get_zipfile

      # Get the file path, minus the extension.
      base = "#{File.dirname(@file_path)}/#{@base_name}"

      # Create the zipfile.
      Zip::File.open("#{base}.zip", Zip::File::CREATE) do |zipfile|
        Dir.glob("#{base}.*") do |file|
          zipfile.add(File.basename(file), file)
        end
      end

      File.read("#{base}.zip")

    end

  end
end
