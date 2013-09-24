
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'confstruct'
require 'yaml'

module Geoloader

  @config = Confstruct::Configuration.new

  # Set configuration options from any hash-like object.
  #
  # @param [Hash] config
  def self.configure config
    @config.configure config
  end

  # Set configuration options from YAML.
  #
  # @param [String] path
  def self.configure_from_yaml path
    @config.configure YAML::load(File.read(File.expand_path(path)))
  end

  # Get the configuration object.
  def self.config
    @config
  end

end

require 'geoloader/asset'
require 'geoloader/geoserver'
require 'geoloader/geonetwork'
require 'geoloader/geotiff'
require 'geoloader/postgis'
require 'geoloader/shapefile'
