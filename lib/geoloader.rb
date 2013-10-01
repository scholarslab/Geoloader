
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'confstruct'
require 'yaml'

module Geoloader

  @config = Confstruct::Configuration.new

  # Set configuration options.
  #
  # @param [Hash] config
  def self.configure(config)
    if config.is_a? String
      @config.configure(YAML::load(File.read(File.expand_path(config))))
    else
      @config.configure(config)
    end
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
