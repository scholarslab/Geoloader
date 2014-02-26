
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

      # Set the file name without the extension.
      @file_base = File.basename(@file_path, ".*")

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
      enqueue
      begin
        yield
      ensure
        dequeue
      end
    end

    private

    #
    # Copy the file and its siblings for manipulation.
    #
    def enqueue

      # Create the warehouse directory.
      @temp = "#{File.dirname(@file_path)}/#{Time.now.to_i}"
      FileUtils.mkdir(@temp)

      # Copy the assets into the archive.
      files = Dir.glob("#{File.dirname(@file_path)}/#{@file_base}.*")
      FileUtils.cp(files, @temp)

      # Update the working file path, saving the original.
      @file_path_ = @file_path
      @file_path = "#{@temp}/#{File.basename(@file_path)}"

    end

    #
    # Delete the working copies, restore the original path.
    #
    def dequeue
      FileUtils.rm_rf(@temp)
      @file_path = @file_path_
    end

  end
end
