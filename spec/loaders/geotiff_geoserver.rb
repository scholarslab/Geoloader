
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "spec_helper"

describe Geoloader::Loaders::GeotiffGeoserver do

  include Geoloader::Tasks
  include FixtureHelpers

  let(:workspace) {
    Geoloader.config.workspaces.testing
  }

  let(:loader) {
    Geoloader::Loaders::GeotiffGeoserver.new(get_fixture_path("geotiff.tif"), workspace)
  }

  before do
    loader.load
  end

  after do
    clear_geoserver(workspace)
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

end
