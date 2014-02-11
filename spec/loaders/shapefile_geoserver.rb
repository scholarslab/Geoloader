
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "spec_helper"

describe Geoloader::ShapefileGeoserverLoader do

  include Geoloader::Tasks
  include FixtureHelpers

  let(:workspace) {
    Geoloader.config.workspaces.testing
  }

  let(:loader) {
    Geoloader::ShapefileGeoserverLoader.new(get_fixture_path("shapefile.shp"), workspace)
  }

  before do
    loader.load
  end

  after do
    clear_geoserver(workspace)
  end

  it "should create a datastore on Geoserver" do

    response = loader.geoserver.resource["workspaces/#{workspace}/datastores/shapefile"].get
    document = Nokogiri::XML(response)

    # Should have the correct name and type 
    document.at_xpath("/dataStore/name").content.must_equal "shapefile"
    document.at_xpath("/dataStore/type").content.must_equal "Shapefile"

    # Should be enabled.
    document.at_xpath("/dataStore/enabled").content.must_equal "true"

  end

  it "should publish a layer on Geoserver" do

    response = loader.geoserver.resource["layers/shapefile"].get
    document = Nokogiri::XML(response)

    # Should have the correct name and type.
    document.at_xpath("/layer/name").content.must_equal "shapefile"
    document.at_xpath("/layer/type").content.must_equal "VECTOR"

  end

end
