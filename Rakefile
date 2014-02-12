# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;
require "bundler/gem_tasks"
require "rake/testtask"
require "resque/tasks"

task :default => [:install, :test]

Rake::TestTask.new do |t|
  t.libs << "spec"
  t.pattern = "spec/loaders/*.rb"
end
