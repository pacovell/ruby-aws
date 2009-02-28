require 'rubygems'
require 'rake'
 
# ----- Default: Testing ------
 
if ENV["RUN_CODE_RUN"] == "true"
  task :default => :"test:rails_compatibility"
else
  task :default => :test
end
 
require 'rake/testtask'
 
Rake::TestTask.new do |t|
  t.libs << 'lib'
  test_files = FileList['test/**/*.rb']
  t.test_files = test_files
  t.verbose = true
end
Rake::Task[:test].send(:add_comment, <<END)
To run with an alternate version of Rails, make test/rails a symlink to that version.
END
 
