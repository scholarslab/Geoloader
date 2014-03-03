
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "fileutils"
require "zip"

module Geoloader
  module Assets


    class Asset

      attr_reader :file_path, :file_base, :workspace, :slug

      #
      # Set the basename and workspace-prefixed slug.
      #
      # @param [String] file_path
      # @param [String] workspace
      #
      def initialize(file_path, workspace)

        @file_path = file_path
        @workspace = workspace

        # File name, with and without extension.
        @file_base = File.basename(@file_path, ".*")
        @file_name = File.basename(@file_path)

        # Set a workspace-prefixed slug.
        @slug = "#{@workspace}_#{@file_base}"

      end

      #
      # Get metadata for Solr document.
      #
      def get_solr_document
        {
          :LayerId => @slug,
          :WorkspaceName => @workspace,
          :Name => @file_base
        }
      end

      #
      # Read the raw ESRI XML.
      #
      # @return [String]
      #
      def get_esri_xml
        File.read("#{@file_path}.xml")
      end

      #
      # Convert the ESRI XML into a iso19139 record.
      #
      # @return [String]
      #
      def get_iso19139_xml
        xslt_path = "#{Geoloader.gem_dir}/lib/geoloader/stylesheets/iso19139.xsl"
        `saxon #{@file_path}.xml #{xslt_path}`
      end

      #
      # Get the ESRI uuid.
      #
      # @return [String]
      #
      def get_esri_uuid
        Nokogiri::XML(get_esri_xml).at_xpath("//thesaName/@uuidref").value
      end

      #
      # Create working copies, yield to a block, remove the copies.
      #
      def stage

        @tempdir = Dir.mktmpdir

        begin

          # Copy the assets into the temp dir.
          files = Dir.glob("#{File.dirname(@file_path)}/#{@file_base}.*")
          FileUtils.cp(files, @tempdir)

          # Change into the temp dir.
          FileUtils.cd(@tempdir) do yield end

        ensure

          # Delete the copies.
          FileUtils.remove_entry @tempdir

        end

      end

    end


    class Geotiff < Asset

      #
      # Remove the black borders added by ArcMap.
      #
      def make_borders_transparent
        gdal_command("gdalwarp -srcnodata 0 -dstalpha", @file_name)
      end

      #
      # (Re)build a EPSG:4326 header.
      #
      def project_to_4326
        gdal_command("gdal_translate -of GTiff -a_srs EPSG:4326", @file_name)
      end

      private

      #
      # Run a gdal command on a file, replacing the original file.
      #
      # @param [String] command
      # @param [String] file_path
      #
      def gdal_command(command, file_path)
        `#{command} #{file_path} #{file_path}_`
        FileUtils.rm(file_path)
        FileUtils.mv("#{file_path}_", file_path)
      end

    end


    class Shapefile < Asset

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
