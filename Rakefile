
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

require 'jeweler'
require 'resque/tasks'

task :default => [:install, :test]

Jeweler::Tasks.new do |gem|
  gem.name    = "geoloader"
  gem.author  = "David McClure"
  gem.email   = "david.mcclure@virginia.edu"
end

task "resque:setup" do
  require './lib/geoloader.rb'
end
