
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module FixtureHelpers

  #
  # Get the full path of a fixture file.
  #
  # @param [String] filename
  #
  def get_fixture_path(filename)
    File.expand_path("../fixtures/#{filename}", File.dirname(__FILE__))
  end

end
