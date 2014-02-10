
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "spec_helper"

describe Geoloader::GeonetworkLoader do

  include Geoloader::Tasks
  include FixtureHelpers

  let(:workspace) {
    Geoloader.config.workspaces.testing
  }

  let(:loader) {
    Geoloader::GeonetworkLoader.new(get_fixture_path("geotiff.tif"), workspace)
  }

  before do
    loader.load
  end

  after do
    clear_geonetwork_group(workspace)
  end

  it "should add a Geonetwork record" do
    # TODO
  end

end
