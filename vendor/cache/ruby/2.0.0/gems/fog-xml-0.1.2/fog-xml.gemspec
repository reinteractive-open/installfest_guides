# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "fog/xml/version"

Gem::Specification.new do |spec|
  spec.name          = "fog-xml"
  spec.version       = Fog::Xml::VERSION
  spec.authors       = ["Wesley Beary (geemus)", "Paul Thornthwaite (tokengeek)", "The fog team"]
  spec.email         = ["geemus@gmail.com", "tokengeek@gmail.com"]
  spec.summary       = "XML parsing for fog providers"
  spec.description   = "Extraction of the XML parsing tools shared between a
                          number of providers in the 'fog' gem"
  spec.homepage      = "https://github.com/fog/fog-xml"
  spec.license       = "MIT"

  files              = `git ls-files -z`.split("\x0")
  files.delete(".hound.yml")
  spec.files = files

  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = %w(lib)

  spec.add_dependency "fog-core"
  spec.add_dependency "nokogiri", "~> 1.5", ">= 1.5.11"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "turn"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "coveralls" if RUBY_VERSION.to_f >= 1.9
end
