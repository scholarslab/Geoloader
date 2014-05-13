
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
