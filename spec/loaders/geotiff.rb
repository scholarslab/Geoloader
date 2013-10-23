
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "spec_helper"

describe Geoloader::GeotiffLoader do

  include FixtureHelpers

  let(:manifest) {
    { :WorkspaceName => "geoloader_test" }
  }

  before do
    @loader = Geoloader::GeotiffLoader.new(get_fixture_path("geotiff.tif"), manifest)
    @loader.load
  end

  after do
    Geoloader::Routines.clear("geoloader_test")
  end

  it "should create a coveragestore on Geoserver" do
    response = @loader.geoserver.resource["workspaces/#{@workspace}/coveragestores/tif"].get
    response.code.must_equal 200
  end

  it "should publish a layer on Geoserver" do
    response = @loader.geoserver.resource["layers/geotiff"].get
    response.code.must_equal 200
  end

  it "should add a Solr document" do
    response = @loader.solr.resource.find({ :queries => "LayerId:#{@loader.geotiff.slug}" })
    response.total.must_equal 1
  end

end
