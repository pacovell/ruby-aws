require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "ruby-aws"
    s.summary = %Q{TODO}
    s.email = "pac@hollownest.com"
    s.homepage = "http://github.com/hollownest/ruby-aws"
    s.description = "TODO"
    s.authors = ["hollownest"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = 'ruby-aws'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib' << 'test'
  t.pattern = 'test/**/*.rb'
  t.verbose = false
end

namespace :test do
	desc "Local tests without the network"
	Rake::TestTask.new(:local) do |t|
		t.libs << 'lib' << 'test'
		t.pattern = 'test/local/*.rb'
		t.verbose = false
	end
	
	desc "Network tests"
	Rake::TestTask.new(:network) do |t|
		t.libs << 'lib' << 'test'
		t.pattern = 'test/network/*.rb'
		t.verbose = false
	end
end

require 'ruby-prof/task'

RubyProf::ProfileTask.new do |t|
  t.test_files = FileList['test/local/*.rb']
  t.output_dir = "/tmp/profile"
  t.printer = :graph_html
  t.min_percent = 10
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |t|
    t.libs << 'test'
    t.test_files = FileList['test/**/*_test.rb']
    t.verbose = true
  end
rescue LoadError
  puts "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
end

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:features)
rescue LoadError
  puts "Cucumber is not available. In order to run features, you must: sudo gem install cucumber"
end

task :default => :test
