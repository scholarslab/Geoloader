
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'geoloader/geotiff'
require 'geoloader/geoserver'

module Geoloader

  def add_raster_to_geoserver(file)

    # Prepare the file.
    tiff = Geoloader::Geotiff.new(file)
    tiff.remove_border
    tiff.rebuild_header
    tiff.cleanup

    # Push to Geoserver.
    # TODO

  end

end
