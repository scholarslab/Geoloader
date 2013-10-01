
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'confstruct'
require 'yaml'

module Geoloader

  # Set default configuration.
  @config = Confstruct::Configuration.new(
    YAML::load(File.read(File.expand_path("../config.yaml", File.dirname(__FILE__))))
  )

  # Set configuration options from any hash-like object.
  #
  # @param [Hash] config
  def self.configure(config)
    @config.configure(config)
  end

  # Set configuration options from YAML.
  #
  # @param [String] path
  def self.configure_from_yaml(path)
    @config.configure(YAML::load(File.read(File.expand_path(path))))
  end

  # Get the configuration object.
  def self.config
    @config
  end

end

# Require assets.
Dir["#{File.dirname(__FILE__)}/geoloader/*.rb"].each { |file|
  require file
}
