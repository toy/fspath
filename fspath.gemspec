# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "fspath"
  s.version = "1.2.0"
  s.platform = "darwin"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ivan Kuchin"]
  s.date = "2011-11-20"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.markdown"
  ]
  s.files = [
    ".tmignore",
    "LICENSE.txt",
    "README.markdown",
    "Rakefile",
    "VERSION",
    "fspath.gemspec",
    "lib/fspath.rb",
    "lib/fspath/all.rb",
    "lib/fspath/darwin.rb",
    "lib/fspath/xattr.rb",
    "spec/fspath/darwin_spec.rb",
    "spec/fspath/xattr_spec.rb",
    "spec/fspath_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = "http://github.com/toy/fspath"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.11"
  s.summary = "Better than Pathname"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ffi-xattr>, [">= 0"])
      s.add_runtime_dependency(%q<rb-appscript>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.1"])
      s.add_development_dependency(%q<rake-gem-ghost>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<ffi-xattr>, [">= 0"])
      s.add_dependency(%q<rb-appscript>, [">= 0"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.1"])
      s.add_dependency(%q<rake-gem-ghost>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<ffi-xattr>, [">= 0"])
    s.add_dependency(%q<rb-appscript>, [">= 0"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.1"])
    s.add_dependency(%q<rake-gem-ghost>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end

