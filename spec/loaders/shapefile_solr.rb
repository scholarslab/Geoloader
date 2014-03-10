
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "spec_helper"

describe Geoloader::Loaders::ShapefileSolr do

  include FixtureHelpers

  let(:workspace) {
    Geoloader.config.workspaces.testing
  }

  let(:loader) {
    Geoloader::Loaders::ShapefileSolr.new(get_fixture_path("shapefile.shp"), workspace)
  }

  before do
    loader.load
  end

  after do
    Geoloader::Tasks::Solr.clear(workspace)
  end

  it "should add a Solr document" do

    response = loader.solr.resource.find({ :queries => "LayerId:#{loader.shapefile.uuid}" })
    response.total.must_equal 1

    # Should point to the correct workspace.
    response.docs[0][:WorkspaceName].must_equal workspace

  end

end
