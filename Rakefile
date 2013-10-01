
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'jeweler'
require 'rake/testtask'

task :default => :test

Jeweler::Tasks.new do |gem|
  gem.name    = "geoloader"
  gem.author  = "David McClure"
  gem.email   = "david.mcclure@virginia.edu"
end

Rake::TestTask.new do |t|
  t.libs << "test"
  t.pattern = "test/integration/*.rb"
end
