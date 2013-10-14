
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'geoloader'
require 'minitest/autorun'
require 'minitest/pride'

class GeoloaderTest < MiniTest::Test

  def setup

    # Configure Geoloader.
    yaml_path = File.expand_path("config.yaml", File.dirname(__FILE__))
    Geoloader.configure(yaml_path)

  end

  def teardown
    puts @loader.geonetwork.count_records_in_group(Geoloader.config.geonetwork.group)
    begin
      @loader.geoserver.delete_workspace(Geoloader.config.geoserver.workspace)
      @loader.geonetwork.delete_group(Geoloader.config.geonetwork.group)
    rescue
    end
  end

end
