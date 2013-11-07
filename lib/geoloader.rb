
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
  # @param [Hash] opts
  #
  def self.configure(opts)
    @config.configure(opts)
  end

  #
  # Set configuration from a YAML file.
  #
  # @param [String] file_path
  #
  def self.configure_from_yaml(file_path)
    @config.configure(YAML::load(File.read(File.expand_path(file_path))))
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
require_dir("geoloader/assets")
require_dir("geoloader/services")
require_dir("geoloader/loaders")
require_dir("geoloader")

# Apply default configuration.
Geoloader.configure_from_yaml(File.expand_path("../../config.yaml", __FILE__))
Geoloader.configure_from_yaml("~/.geoloader.yaml") rescue nil
