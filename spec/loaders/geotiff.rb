
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "spec_helper"
require "nokogiri"

describe Geoloader::GeotiffLoader do

  include FixtureHelpers

  let(:workspace) {
    Geoloader.config.test.workspace
  }

  let(:loader) {
    Geoloader::GeotiffLoader.new(get_fixture_path("geotiff.tif"), {
      :WorkspaceName => workspace
    })
  }

  before do
    loader.load
  end

  after do
    Geoloader::Routines.clear(workspace)
  end

  it "should create a coveragestore on Geoserver" do

    response = loader.geoserver.resource["workspaces/#{workspace}/coveragestores/geotiff"].get
    document = Nokogiri::XML(response)

    # Should have the correct name and type 
    document.at_xpath("/coverageStore/name").content.must_equal "geotiff"
    document.at_xpath("/coverageStore/type").content.must_equal "GeoTIFF"

    # Should be enabled.
    document.at_xpath("/coverageStore/enabled").content.must_equal "true"

  end

  it "should publish a layer on Geoserver" do

    response = loader.geoserver.resource["layers/geotiff"].get
    document = Nokogiri::XML(response)

    # Should have the correct name and type.
    document.at_xpath("/layer/name").content.must_equal "geotiff"
    document.at_xpath("/layer/type").content.must_equal "RASTER"

  end

  it "should add a Solr document" do

    response = loader.solr.resource.find({ :queries => "LayerId:#{loader.asset.slug}" })
    response.total.must_equal 1

    # Should point to the correct workspace.
    response.docs[0][:WorkspaceName].must_equal workspace

  end

end
