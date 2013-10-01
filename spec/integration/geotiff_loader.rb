
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'spec_helper'

describe Geoloader::GeotiffLoader do

  before do

    # Configure Geoloader.
    yaml_path = File.expand_path("../config.yaml", File.dirname(__FILE__))
    Geoloader.configure(yaml_path)

    # Load the GeoTIFF.
    file_path = File.expand_path("../fixtures/nyc.tif", File.dirname(__FILE__))
    @loader = Geoloader::GeotiffLoader.new(file_path)
    @loader.load

  end

  it "should create a new coveragestore on Geoserver"

  it "should publish a new layer on Geoserver"

end

