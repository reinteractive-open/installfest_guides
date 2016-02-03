# -*- encoding: utf-8 -*-
# stub: fog-xenserver 0.2.2 ruby lib

Gem::Specification.new do |s|
  s.name = "fog-xenserver"
  s.version = "0.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Paulo Henrique Lopes Ribeiro"]
  s.date = "2015-04-13"
  s.description = "Module for the 'fog' gem to support XENSERVER."
  s.email = "plribeiro3000@gmail.com"
  s.homepage = "https://github.com/fog/fog-xenserver"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.6"
  s.summary = "This library can be used as a module for `fog` or as standalone provider to use the XENSERVER in applications."

  s.installed_by_version = "2.4.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<fog-xml>, [">= 0"])
      s.add_runtime_dependency(%q<fog-core>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<minitest>, [">= 0"])
      s.add_development_dependency(%q<turn>, [">= 0"])
      s.add_development_dependency(%q<pry>, [">= 0"])
      s.add_development_dependency(%q<vcr>, [">= 0"])
      s.add_development_dependency(%q<webmock>, [">= 0"])
      s.add_development_dependency(%q<coveralls>, [">= 0"])
    else
      s.add_dependency(%q<fog-xml>, [">= 0"])
      s.add_dependency(%q<fog-core>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<minitest>, [">= 0"])
      s.add_dependency(%q<turn>, [">= 0"])
      s.add_dependency(%q<pry>, [">= 0"])
      s.add_dependency(%q<vcr>, [">= 0"])
      s.add_dependency(%q<webmock>, [">= 0"])
      s.add_dependency(%q<coveralls>, [">= 0"])
    end
  else
    s.add_dependency(%q<fog-xml>, [">= 0"])
    s.add_dependency(%q<fog-core>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<minitest>, [">= 0"])
    s.add_dependency(%q<turn>, [">= 0"])
    s.add_dependency(%q<pry>, [">= 0"])
    s.add_dependency(%q<vcr>, [">= 0"])
    s.add_dependency(%q<webmock>, [">= 0"])
    s.add_dependency(%q<coveralls>, [">= 0"])
  end
end
