
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'minitest_helper'

class GeotiffLoaderTest < GeoloaderTest

  def setup

    super

    # Load the GeoTIFF.
    file_path = File.expand_path("../fixtures/tif.tif", File.dirname(__FILE__))
    @loader = Geoloader::GeotiffLoader.new(file_path)
    @loader.load

  end

  def test_create_geoserver_coveragestore
    response = @loader.geoserver.resource["workspaces/#{@workspace}/coveragestores/tif"].get
    assert_equal 200, response.code
  end

  def test_publish_geoserver_layer
    response = @loader.geoserver.resource["layers/tif"].get
    assert_equal 200, response.code
  end

end
