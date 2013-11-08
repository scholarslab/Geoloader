
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "spec_helper"
require "nokogiri"

describe Geoloader::ShapefileSolrLoader do

  include Geoloader::Tasks
  include FixtureHelpers

  let(:workspace) {
    Geoloader.config.workspaces.testing
  }

  let(:loader) {
    Geoloader::ShapefileSolrLoader.new(get_fixture_path("shapefile.shp"), workspace)
  }

  before do
    loader.load
  end

  after do
    clear_solr_workspace(workspace)
  end

  it "should add a Solr document" do

    response = loader.solr.resource.find({ :queries => "LayerId:#{loader.shapefile.slug}" })
    response.total.must_equal 1

    # Should point to the correct workspace.
    response.docs[0][:WorkspaceName].must_equal workspace

  end

end
