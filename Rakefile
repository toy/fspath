require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

name = 'fspath'
summary = 'Better than Pathname'

require 'jeweler'
[nil].each do |platform|
  Jeweler::Tasks.new do |gem|
    gem.name = name
    gem.homepage = "http://github.com/toy/fspath"
    gem.summary = summary
    gem.authors = ["Boba Fat"]
    gem.platform = platform
    if platform == 'darwin'
      gem.add_dependency 'rb-appscript'
    end
  end
  Jeweler::RubygemsDotOrgTasks.new
end

desc "Replace system gem with symlink to this folder"
task 'ghost' do
  gem_path = Gem.searcher.find(name).full_gem_path
  current_path = File.expand_path('.')
  system('rm', '-r', gem_path)
  system('ln', '-s', current_path, gem_path)
end

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.rspec_opts = ['--colour --format progress']
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.rspec_opts = ['--colour --format progress']
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
  spec.rcov_opts = ['--exclude', 'spec']
end

task :spec_with_rcov_and_open => :rcov do
  `open coverage/index.html`
end

desc 'Default: run specs.'
task :default => :spec_with_rcov_and_open
