
require "bundler/gem_tasks"
require "rake/testtask"

task :default => [:install, :test]

Rake::TestTask.new do |t|
  t.libs << "spec"
  t.pattern = "spec/loaders/*.rb"
end
