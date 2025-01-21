# encoding: UTF-8

Gem::Specification.new do |s|
  s.name        = 'fspath'
  s.version     = '3.1.2'
  s.summary     = %q{Better than Pathname}
  s.homepage    = "https://github.com/toy/#{s.name}"
  s.authors     = ['Ivan Kuchin']
  s.license     = 'MIT'

  s.metadata = {
    'bug_tracker_uri'   => "https://github.com/toy/#{s.name}/issues",
    'documentation_uri' => "https://www.rubydoc.info/gems/#{s.name}/#{s.version}",
    'source_code_uri'   => "https://github.com/toy/#{s.name}",
  } if s.respond_to?(:metadata=)

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = %w[lib]

  s.add_development_dependency 'rspec', '~> 3.0'
  if RUBY_VERSION >= '2.5' && !Gem.win_platform?
    s.add_development_dependency 'rubocop', '~> 1.22', '!= 1.22.2'
    s.add_development_dependency 'rubocop-rspec', '~> 3.4'
  end
end
