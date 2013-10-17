
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class BatchLoader

    #
    # Read batch manifest and metadata.
    #
    # @param [String] file_name
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
          loader = Geoloader::GeotiffLoader.new(file, @yaml)
          loader.load
        when ".shp"
          loader = Geoloader::ShapefileLoader.new(file, @yaml)
          loader.load
        end
      end

    end

  end
end
