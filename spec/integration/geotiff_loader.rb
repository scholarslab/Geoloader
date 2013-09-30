
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'spec_helper'

describe Geoloader::GeotiffLoader do

  before do

    @geoserver = Geoloader::Geoserver.new

    # Configure Geoloader.
    yaml = File.expand_path("../config.yaml", File.dirname(__FILE__))
    Geoloader.configure(yaml)

    # Load the GeoTIFF.
    file = File.expand_path("../fixtures/nyc.tif", File.dirname(__FILE__))
    @loader = Geoloader::GeotiffLoader.new(file)
    @loader.load

  end

  after do
    # TODO: Delete stores.
    puts @geoserver
  end

  it "should create a new coveragestore on Geoserver" do
    # TODO
  end

  it "should publish a new layer on Geoserver" do
    # TODO
  end

end

