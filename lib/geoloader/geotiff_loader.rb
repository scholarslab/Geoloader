
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class GeotiffLoader < Loader

    attr_reader :geotiff

    # @param [String] file_path
    def initialize(file_path)
      @geotiff = Geoloader::Geotiff.new(file_path)
      super()
    end

    def load

      # Prepare the file.
      @geotiff.remove_border
      @geotiff.convert_to_4326

      # Push to Geoserver.
      @geoserver.create_coveragestore(@geotiff)
      #@geonetwork.create_record(@geotiff)

    end

    def unload
      @geoserver.delete_coveragestore(@geotiff)
    end

  end
end
