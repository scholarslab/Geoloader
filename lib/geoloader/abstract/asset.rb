
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "fileutils"

module Geoloader
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
end
