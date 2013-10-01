
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'minitest_helper'

class ShapefileLoaderTest < GeoloaderTest

  def setup

    super

    # Load the Shapefile.
    file_path = File.expand_path("../fixtures/shapefile.shp", File.dirname(__FILE__))
    @loader = Geoloader::ShapefileLoader.new(file_path)
    @loader.load

  end

  def teardown
    super
    @loader.shapefile.drop_database
  end

  def test_create_postgis_database
    assert_equal ["shapefile"], @loader.shapefile.get_layers
  end

  def test_create_new_datastore
    assert_equal 200, @geoserver.resource["workspaces/#{@workspace}/datastores/shapefile"].get.code
  end

  def test_publish_new_layer
    assert_equal 200, @geoserver.resource["layers/shapefile"].get.code
  end

end
