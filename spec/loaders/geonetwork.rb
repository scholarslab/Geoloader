
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

  let(:uuid) {
    loader.asset.get_esri_uuid
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