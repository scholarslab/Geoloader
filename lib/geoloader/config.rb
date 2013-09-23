
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

module Geoloader

  @config = Confstruct::Configuration.new do
    geoserver do
      url        "http://admin:geoserver@localhost:8080/geoserver/rest"
      username   "admin"
      password   "geoserver"
      workspace  "geoloader"
    end
    geonetwork do
      url        "http://localhost:8080/geonetwork/srv/en"
      username   "admin"
      password   "admin"
      group      2
    end
  end

  def self.Config
    @config
  end

end
