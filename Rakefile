require 'rubygems'
require 'rake'
require 'jeweler'
require 'rake/gem_ghost_task'
require 'rspec/core'
require 'rspec/core/rake_task'

name = 'fspath'

[nil, 'darwin'].each do |platform|
  spec = Gem::Specification.new do |gem|
    gem.name = name
    gem.summary = %Q{Better than Pathname}
    gem.homepage = "http://github.com/toy/#{name}"
    gem.license = 'MIT'
    gem.authors = ['Boba Fat']
    gem.platform = platform
    gem.add_dependency 'xattr'
    if platform == 'darwin'
      gem.add_dependency 'rb-appscript'
    end
    gem.add_development_dependency 'jeweler', '~> 1.5.1'
    gem.add_development_dependency 'rake-gem-ghost'
    gem.add_development_dependency 'rspec'
  end
  Jeweler::RubygemsDotOrgTasks.new do |rubygems_tasks|
    rubygems_tasks.jeweler = Jeweler::Tasks.new(spec).jeweler
  end
  Rake::GemGhostTask.new
end

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.rspec_opts = ['--colour --format progress']
  spec.pattern = 'spec/**/*_spec.rb'
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.rspec_opts = ['--colour --format progress']
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec_with_rcov_and_open => :rcov do
  `open coverage/index.html`
end

desc 'Default: run specs.'
task :default => :spec_with_rcov_and_open
