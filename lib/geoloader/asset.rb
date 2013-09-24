
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'fileutils'

module Geoloader
  class Asset

    attr_reader :file_name, :file_path, :base_name

    def initialize filename
      @file_name = name
      @base_name = File.basename @file_name, ".*"
      @file_path = "#{Geoloader.config.directory}/#{@file_name}"
    end

  end
end
