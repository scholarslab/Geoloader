
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader
  class GeotiffJob

    @queue = :geoloader

    def self.perform(file_path, metadata)
      Geoloader::GeotiffLoader.new(file_path, metadata).load
    end

  end
end
