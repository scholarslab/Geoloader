# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'geoloader/version'

Gem::Specification.new do |spec|
  spec.name             = "geoloader"
  spec.version          = Geoloader::VERSION
  spec.authors          = ["David McClure"]
  spec.email            = ["david.mcclure@virginia.edu"]
  spec.summary          = "Helpers for managing GIS metadata with Geoserver, Geonetwork, and Solr"
  spec.description       = %q{Helpers for managing GIS metadata with Geoserver, Geonetwork, and Solr}
  spec.homepage         = "https://github.com/scholarslab/Geoloader"
  spec.license          = "Apache 2"

  spec.files            = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rest-client", "~> 1.6.7"
  spec.add_dependency "confstruct", "~> 0.2.5"
  spec.add_dependency "rsolr-ext", "~> 1.0.3"
  spec.add_dependency "thor", "~> 0.18.1"
  spec.add_dependency "terminal-table", "~> 1.4.5"
  spec.add_dependency "resque", "~> 1.25.1"
  spec.add_dependency "yajl-ruby", "~> 1.2.0"
  spec.add_dependency "nokogiri", "~> 1.6.1"
  spec.add_dependency "rubyzip", "~> 1.1.0"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.14.1"
end

