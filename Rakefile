
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require "jeweler"
require "rake/testtask"
require "resque/tasks"

task :default => [:install, :test]

Jeweler::Tasks.new do |gem|
  gem.name        = "geoloader"
  gem.author      = "David McClure"
  gem.homepage    = "https://github.com/scholarslab/Geoloader"
  gem.email       = "david.mcclure@virginia.edu"
  gem.license     = "Apache-2.0"
end

Rake::TestTask.new do |t|
  t.libs << "spec"
  t.pattern = "spec/loaders/*.rb"
end

task :console do
  require 'irb'
  require 'irb/completion'
  require 'geoloader'
  ARGV.clear
  IRB.start
end
