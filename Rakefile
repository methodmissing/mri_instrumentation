require 'rake'
require 'rake/testtask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test MRI instrumentation'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "mri_instrumentation"
    s.summary = "Piggy backs of the dtrace pid provider for visibility into the Ruby VM"
    s.email = "lourens@methodmissing.com"
    s.homepage = "http://github.com/methodmissing/mri_instrumentation"
    s.description = "Piggy backs of the dtrace pid provider for visibility into the Ruby VM."
    s.authors = ["Lourens Naudé"]
    s.files = FileList["[A-Z]*", "{lib,test,rails,tasks,probes}/**/*"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end