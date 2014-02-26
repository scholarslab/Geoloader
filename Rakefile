
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "rake/testtask"
require "jeweler"

task :default => [:install, :test]

Jeweler::Tasks.new do |gem|
  gem.name      = "geoloader"
  gem.author    = "David McClure"
  gem.homepage  = "https://github.com/scholarslab/Geoloader"
  gem.email     = "david.mcclure@virginia.edu"
  gem.license   = "Apache-2.0"
end

Rake::TestTask.new do |t|
  t.libs << "spec"
  t.pattern = "spec/loaders/*.rb"
end
