
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'spec_helper'

describe Geoloader::GeotiffLoader do

  before do

    # Configure Geoloader.
    yaml_path = File.expand_path("../config.yaml", File.dirname(__FILE__))
    Geoloader.configure(yaml_path)

    # Alias the testing workspace.
    @workspace = Geoloader.config.geoserver.workspace

    # Create the testing workspace.
    @geoserver = Geoloader::Geoserver.new
    @geoserver.create_workspace(@workspace)

    # Load the GeoTIFF.
    file_path = File.expand_path("../fixtures/nyc.tif", File.dirname(__FILE__))
    @loader = Geoloader::GeotiffLoader.new(file_path)
    @loader.load

  end

  after do

    # Delete the workspace.
    @geoserver.delete_workspace(@workspace)

  end

  it "should create a new coveragestore on Geoserver" do
    @geoserver.resource["workspaces/#{@workspace}/coveragestores/nyc"].get.code.must_equal 200
  end

  it "should publish a new layer on Geoserver"

end

