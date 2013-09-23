
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader

  @config = Confstruct::Configuration.new do
    geoserver do
      url        "http://admin:geoserver@localhost:8080/geoserver/rest"
      username   "admin"
      password   "geoserver"
      workspace  "geoloader"
    end
  end

  def self.config
    @config
  end

end
