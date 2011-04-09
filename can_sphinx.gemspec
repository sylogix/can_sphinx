# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "can_sphinx/version"

Gem::Specification.new do |s|
  s.name        = "can_sphinx"
  s.version     = CanSphinx::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Florent Piteau"]
  s.email       = ["florent.piteau@sylogix.net"]
  s.homepage    = "https://github.com/sylogix/can_sphinx"
  s.summary     = %q{Use CanCan when searching with ThinkingSphinx.}
  s.description = %q{CanSphinx allows you to use CanCan for authorizing resources searched by ThinkingSphinx.}

  s.add_dependency('thinking-sphinx')
  s.add_dependency('cancan')

  s.rubyforge_project = s.name

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
