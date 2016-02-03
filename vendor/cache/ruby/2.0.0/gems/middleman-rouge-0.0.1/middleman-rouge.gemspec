# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'middleman-rouge/version'

Gem::Specification.new do |gem|
  gem.name          = "middleman-rouge"
  gem.version       = Middleman::Rouge::VERSION
  gem.authors       = ["Linus Pettersson"]
  gem.email         = ["linus.pettersson@gmail.com"]
  gem.description   = %q{Rouge syntax highlighting for Middleman}
  gem.summary       = %q{Rouge syntax highlighting for Middleman}
  gem.homepage      = "http://rubygems.org/gems/middleman-rouge"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency("middleman-core", [">= 3.0.0"])
  gem.add_runtime_dependency("redcarpet", [">= 2.2.0"])
  gem.add_runtime_dependency("rouge", [">= 0.3.0"])
end
