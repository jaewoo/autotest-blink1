# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "autotest-blink1/version"

Gem::Specification.new do |s|
  s.name        = "autotest-blink1"
  s.version     = Autotest::Blink1::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jaewoo Kim"]
  s.email       = ["kim.jaewoo@gmail.com"]
  s.homepage    = "http://github.com/jaewoo/autotest-blink1"
  s.summary     = %q{Blink(1) notification support for autotest}
  s.description = %q{This gem aims to improve support for Blink(1) notifications by autotest.}

  s.rubyforge_project = "autotest-blink1"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.post_install_message = "\e[1;32m\n" + ('-' * 79) + "\n\n" + File.read('PostInstall.txt') + "\n" + ('-' * 79) + "\n\e[0m"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "ZenTest"
  s.add_development_dependency "autotest-fsevent"
end
