
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "minitest_helper"

class GeotiffLoaderTest < GeoloaderTest

  def setup
    manifest = { :WorkspaceName => "geoloader_test" }
    @loader = Geoloader::GeotiffLoader.new(get_fixture_path("geotiff.tif"), manifest)
    @loader.load
  end

  def teardown
    Geoloader::Routines.clear("geoloader_test")
  end

  def test_create_geoserver_coveragestore
    response = @loader.geoserver.resource["workspaces/#{@workspace}/coveragestores/tif"].get
    assert_equal 200, response.code
  end

  def test_publish_geoserver_layer
    response = @loader.geoserver.resource["layers/geotiff"].get
    assert_equal 200, response.code
  end

  def test_create_solr_record
    response = @loader.solr.resource.find({ :queries => "LayerId:#{@loader.geotiff.slug}" })
    assert_equal 1, response.total
  end

end
