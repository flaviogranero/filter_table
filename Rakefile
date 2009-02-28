require 'rake'
require 'rake/testtask'
require 'date'
 
 
desc "Run the test suite"
task :default => :test

test_files_pattern = 'test/*_test.rb'
desc "Test filter_table plugin"
Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.pattern = test_files_pattern
  t.verbose = false
end