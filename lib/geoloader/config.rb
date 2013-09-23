
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'confstruct'
require 'yaml'

module Geoloader

  @config = Confstruct::Configuration.new do
    geoserver do
      url       "http://admin:geoserver@localhost:8080/geoserver/rest"
      username  "admin"
      password  "geoserver"
      workspace "geoloader"
    end
  end

  # Set configuration options from YAML.
  #
  # @param [String] path
  def self.configure path
    @config.configure YAML::load(File.read(path))
  end

  # Get the configuration object.
  def self.config
    @config
  end

end
