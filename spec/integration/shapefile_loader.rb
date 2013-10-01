
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'minitest_helper'

class ShapefileLoaderTest < GeoloaderTest

  def setup

    super

    # Load the Shapefile.
    file_path = File.expand_path("../fixtures/cville.shp", File.dirname(__FILE__))
    @loader = Geoloader::ShapefileLoader.new(file_path)
    @loader.load

  end

  def teardown
    super
    @loader.shapefile.drop_database
  end

  def test_create_postgis_database
    # TODO
  end

  def test_create_new_datastore
    # TODO
  end

  def test_publish_new_layer
    # TODO
  end

end
