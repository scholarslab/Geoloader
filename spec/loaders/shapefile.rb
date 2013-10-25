
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "spec_helper"
require "nokogiri"

describe Geoloader::ShapefileLoader do

  include FixtureHelpers

  let(:workspace) {
    Geoloader.config.test.workspace
  }

  let(:loader) {
    Geoloader::ShapefileLoader.new(get_fixture_path("shapefile.shp"), {
      :WorkspaceName => workspace
    })
  }

  before do
    loader.load
  end

  after do
    Geoloader::Routines.clear(workspace)
  end

  it "should create a datastore on Geoserver" do

    response = loader.geoserver.resource["workspaces/#{workspace}/datastores/shapefile"].get
    document = Nokogiri::XML(response)

    # Should have the correct name and type 
    document.at_xpath("/dataStore/name").content.must_equal "shapefile"
    document.at_xpath("/dataStore/type").content.must_equal "PostGIS"

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

  it "should add a Solr document" do

    response = loader.solr.resource.find({ :queries => "LayerId:#{loader.asset.slug}" })
    response.total.must_equal 1

    # Should point to the correct workspace.
    response.docs[0][:WorkspaceName].must_equal workspace

  end

end
