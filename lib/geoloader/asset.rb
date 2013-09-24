
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'fileutils'

module Geoloader
  class Asset

    attr_reader :filename, :filepath, :basename

    def initialize filename
      @filename = name
      @filepath = "#{Geoloader.config.directory}/#{@name}"
      @basename = File.basename @name, ".*"
    end

  end
end
