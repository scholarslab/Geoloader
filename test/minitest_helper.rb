
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'geoloader'
require 'minitest/autorun'
require 'minitest/pride'

class GeoloaderTest < MiniTest::Test

  def setup

    # Configure Geoloader.
    yaml_path = File.expand_path("config.yaml", File.dirname(__FILE__))
    Geoloader.configure(yaml_path)

    # Alias the testing workspace/group.
    @workspace = Geoloader.config.geoserver.workspace
    @group = Geoloader.config.geonetwork.group

    # Create the testing Geoserver workspace.
    @geoserver = Geoloader::Geoserver.new
    @geoserver.create_workspace(@workspace)

    # Create the testing Geonetwork group.
    @geonetwork = Geoloader::Geonetwork.new

  end

  def teardown
    @geoserver.delete_workspace(@workspace)
    @geonetwork.delete_group(@group)
  end

end
