
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "spec_helper"

describe Geoloader::Loaders::Geonetwork do

  include Geoloader::CLI::Tasks
  include FixtureHelpers

  let(:workspace) {
    Geoloader.config.workspaces.testing
  }

  let(:loader) {
    Geoloader::Loaders::Geonetwork.new(get_fixture_path("geotiff.tif"), workspace)
  }

  let(:uuid) {
    loader.asset.uuid
  }

  before do
    loader.load
  end

  after do
    loader.geonetwork.delete_record(loader.asset)
  end

  it "should add a Geonetwork record" do

    response = loader.geonetwork.get_record(loader.asset)
    document = Nokogiri::XML(response)

    # Should create a record.
    document.at_xpath("//gmd:fileIdentifier/gco:CharacterString").content.must_equal uuid

  end

end
