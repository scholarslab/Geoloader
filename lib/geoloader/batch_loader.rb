
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'resque'

module Geoloader
  class BatchLoader

    #
    # Read batch manifest and metadata.
    #
    # @param [String] file_path
    # @param [Boolean] enqueue
    #
    def initialize(file_path, enqueue = false)
      @file_path = File.expand_path(file_path)
      @metadata = YAML::load(File.read(@file_path))
    end

    #
    # Expand the file manifest and load each asset.
    #
    def load

      Dir.glob("#{File.dirname(@file_path)}/#{@metadata["files"]}") do |file|
        case File.extname(file)
        when ".tif"
          Resque.enqueue(Geoloader::GeotiffJob, file, @metadata)
        when ".shp"
          Resque.enqueue(Geoloader::ShapefileJob, file, @metadata)
        end
      end

    end

  end
end
