# -*- encoding: utf-8 -*-
# stub: pmap 1.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "pmap"
  s.version = "1.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Bruce Adams", "Jake Goulding", "David Biehl"]
  s.date = "2015-11-21"
  s.description = "Add parallel methods into Enumerable: pmap and peach"
  s.email = ["bruce.adams@acm.org", "jake.goulding@gmail.com", "me@davidbiehl.com"]
  s.homepage = "https://github.com/bruceadams/pmap"
  s.licenses = ["Apache-2.0"]
  s.rubygems_version = "2.4.6"
  s.summary = "Add parallel methods into Enumerable: pmap and peach"

  s.installed_by_version = "2.4.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<test-unit>, [">= 0"])
    else
      s.add_dependency(%q<test-unit>, [">= 0"])
    end
  else
    s.add_dependency(%q<test-unit>, [">= 0"])
  end
end
