
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'minitest_helper'

class ShapefileLoaderTest < GeoloaderTest

  def setup

    super

    # Load the Shapefile.
    file_path = File.expand_path("../fixtures/shp.shp", File.dirname(__FILE__))
    @loader = Geoloader::ShapefileLoader.new(file_path)
    @loader.load

  end

  def teardown
    super
    @loader.shapefile.drop_database
  end

  def test_create_geoserver_datastore
    response = @loader.geoserver.resource["workspaces/#{@workspace}/datastores/shp"].get
    assert_equal 200, response.code
  end

  def test_publish_geoserver_layer
    response = @loader.geoserver.resource["layers/shp"].get
    assert_equal 200, response.code
  end

  def test_create_geonetwork_record
    # TODO
  end

end
