
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "confstruct"
require "require_all"
require "yaml"

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
  # Get the root gem directory.
  #
  def self.gem_dir
    File.expand_path("../../", __FILE__)
  end

  #
  # Get the configuration object.
  #
  def self.config
    @config
  end

end

require_rel("geoloader")

# Apply default configuration.
Geoloader.configure_from_yaml("#{Geoloader.gem_dir}/config.yaml")
Geoloader.configure_from_yaml("~/.geoloader.yaml") rescue nil
