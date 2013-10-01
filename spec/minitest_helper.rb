
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'geoloader'
require 'minitest/autorun'
require 'minitest/pride'

class GeoloaderTest < MiniTest::Unit::TestCase

  def setup

    # Configure Geoloader.
    yaml_path = File.expand_path("config.yaml", File.dirname(__FILE__))
    Geoloader.configure(yaml_path)

    # Alias the testing workspace name.
    @workspace = Geoloader.config.geoserver.workspace

    # Create the testing workspace.
    @geoserver = Geoloader::Geoserver.new
    @geoserver.create_workspace(@workspace)

  end

  def teardown
    @geoserver.delete_workspace(@workspace)
  end

end
