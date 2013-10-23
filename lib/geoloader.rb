
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "confstruct"
require "yaml"

#
# Require all files in a directory.
#
# @param [String] path
#
def require_dir(path)
  Dir["#{File.dirname(__FILE__)}/#{path}/*.rb"].each { |file|
    require file
  }
end

module Geoloader

  @config = Confstruct::Configuration.new

  #
  # Set configuration options.
  #
  # @param [Hash] config
  #
  def self.configure(config = "~/.geoloader/config.yaml")
    if config.is_a?(String)
      @config.configure(YAML::load(File.read(File.expand_path(config))))
    else
      @config.configure(config)
    end
  end

  #
  # Get the configuration object.
  #
  def self.config
    @config
  end

end

# Load assets.
require_dir("geoloader/abstract")
require_dir("geoloader")

# Set defaults.
Geoloader.configure
