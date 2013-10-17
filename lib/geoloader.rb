
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'confstruct'
require 'yaml'

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
  def self.configure(config)
    if config.is_a? String
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

require_dir("geoloader/abstract")
require_dir("geoloader")
