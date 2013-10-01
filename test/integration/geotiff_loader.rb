
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'minitest_helper'

class GeotiffLoaderTest < GeoloaderTest

  def setup

    super

    # Load the GeoTIFF.
    file_path = File.expand_path("../fixtures/geotiff.tif", File.dirname(__FILE__))
    @loader = Geoloader::GeotiffLoader.new(file_path)
    @loader.load

  end

  def test_create_coveragestore
    assert_equal 200, @geoserver.resource["workspaces/#{@workspace}/coveragestores/geotiff"].get.code
  end

  def test_publish_new_layer
    assert_equal 200, @geoserver.resource["layers/geotiff"].get.code
  end

end
