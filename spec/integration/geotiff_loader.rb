
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'geoloader'
require 'minitest/autorun'

describe Geoloader::GeotiffLoader do

  before do

    # Configure Geoloader.
    yaml = File.expand_path("../config.yaml", File.dirname(__FILE__))
    Geoloader.configure_from_yaml(yaml)

    # Load the GeoTIFF.
    file = File.expand_path("../fixtures/nyc.tif", File.dirname(__FILE__))
    @loader = Geoloader::GeotiffLoader.new(file)
    @loader.load

  end

  after do
    @loader.unload
  end

  it "should create a new coveragestore on Geoserver" do
    # TODO
  end

  it "should publish a new layer on Geoserver" do
    # TODO
  end

end
