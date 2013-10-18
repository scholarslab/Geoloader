
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'resque'

module Geoloader
  class BatchLoader

    #
    # Read batch manifest and metadata.
    #
    # @param [String] file_path
    #
    def initialize(file_path)
      @file_path = File.expand_path(file_path)
      @yaml = YAML::load(File.read(@file_path))
    end

    #
    # Expand the file manifest and load each asset.
    #
    def load

      Dir.glob("#{File.dirname(@file_path)}/#{@yaml["files"]}") do |file|
        case File.extname(file)
        when ".tif"
          Resque.enqueue(Geoloader::GeotiffJob, file, @yaml)
        when ".shp"
          Resque.enqueue(Geoloader::ShapefileJob, file, @yaml)
        end
      end

    end

  end
end
