
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "fileutils"

module Geoloader
  class Asset

    attr_reader :file_path, :base_name, :workspace, :slug

    #
    # Set the basename and workspace-prefixed slug.
    #
    # @param [String] file_path
    # @param [String] workspace
    # @param [Hash] metadata
    #
    def initialize(file_path, workspace, metadata)

      @file_path = file_path
      @workspace = workspace
      @metadata  = metadata

      # Set the file name without the extension.
      @base_name = File.basename(@file_path, ".*")

      # Set a workspace-prefixed slug.
      @slug = "#{@workspace}_#{@base_name}"

    end

    #
    # Get metadata for Solr document.
    #
    def get_solr_document
      @metadata.merge({
        :LayerId => @slug,
        :WorkspaceName => @workspace,
        :Name => @base_name
      })
    end

    #
    # Convert the raw XML into a iso19139 record.
    #
    # @return [String]
    #
    def get_iso19139_xml
      xslt_path = "#{Geoloader.gem_dir}/stylesheets/iso19139.xsl"
      `saxon #{@file_path}.xml #{xslt_path}`
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
      @copies = "#{File.dirname(@file_path)}/#{Time.now.to_i}"
      FileUtils.mkdir(@copies)

      # Copy the assets into the archive.
      files = Dir.glob("#{File.dirname(@file_path)}/#{@base_name}.*")
      FileUtils.cp(files, @copies)

      # Update the working file path, saving the original.
      @file_path_ = @file_path
      @file_path = "#{@copies}/#{File.basename(@file_path)}"

    end

    #
    # Delete the working copies, restore the original path.
    #
    def dequeue
      FileUtils.rm_rf(@copies)
      @file_path = @file_path_
    end

  end
end
