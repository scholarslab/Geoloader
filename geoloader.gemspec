# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'geoloader/version'

Gem::Specification.new do |s|

  s.name          = "geoloader"
  s.version       = Geoloader::VERSION
  s.authors       = ["David McClure"]
  s.email         = ["david.mcclure@virginia.edu"]
  s.summary       = "Helpers for managing GIS metadata."
  s.description   = "Load GeoTIFFs and Shapefiles to Geoserver, Geonetwork, and Solr."
  s.homepage      = "https://github.com/scholarslab/Geoloader"
  s.license       = "Apache 2"

  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_development_dependency "bundler", "~> 1.5",   ">= 1.5.3"
  s.add_development_dependency "rake",    "~> 10.1",  ">= 10.1.1"
  s.add_development_dependency "rspec",   "~> 2.14",  ">= 2.14.1"

  s.add_dependency "require_all", "~> 1.3",   ">= 1.3.2"
  s.add_dependency "rsolr-ext",   "~> 1.0",   ">= 1.0.3"
  s.add_dependency "rest-client", "~> 1.6",   ">= 1.6.7"
  s.add_dependency "thor",        "~> 0.18",  ">= 0.18.1"
  s.add_dependency "confstruct",  "~> 0.2",   ">= 0.2.5"
  s.add_dependency "resque",      "~> 1.25",  ">= 1.25.1"
  s.add_dependency "nokogiri",    "~> 1.6",   ">= 1.6.1"
  s.add_dependency "rubyzip",     "~> 1.1",   ">= 1.1.0"
  s.add_dependency "jekyll",      "~> 1.4",   ">= 1.4.3"

end
