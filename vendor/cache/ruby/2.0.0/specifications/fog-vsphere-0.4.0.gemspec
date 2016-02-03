# -*- encoding: utf-8 -*-
# stub: fog-vsphere 0.4.0 ruby lib

Gem::Specification.new do |s|
  s.name = "fog-vsphere"
  s.version = "0.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["J.R. Garcia"]
  s.date = "2015-12-15"
  s.description = "This library can be used as a module for `fog` or as standalone provider to use vSphere in applications."
  s.email = ["jrg@vmware.com"]
  s.homepage = "https://github.com/fog/fog-vsphere"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7")
  s.rubygems_version = "2.4.6"
  s.summary = "Module for the 'fog' gem to support VMware vSphere."

  s.installed_by_version = "2.4.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<fog-core>, [">= 0"])
      s.add_runtime_dependency(%q<rbvmomi>, ["~> 1.8"])
      s.add_development_dependency(%q<bundler>, ["~> 1.10"])
      s.add_development_dependency(%q<pry>, ["~> 0.10"])
      s.add_development_dependency(%q<rake>, ["~> 10.0"])
      s.add_development_dependency(%q<rubocop>, ["~> 0.34"])
      s.add_development_dependency(%q<shindo>, ["~> 0.3"])
    else
      s.add_dependency(%q<fog-core>, [">= 0"])
      s.add_dependency(%q<rbvmomi>, ["~> 1.8"])
      s.add_dependency(%q<bundler>, ["~> 1.10"])
      s.add_dependency(%q<pry>, ["~> 0.10"])
      s.add_dependency(%q<rake>, ["~> 10.0"])
      s.add_dependency(%q<rubocop>, ["~> 0.34"])
      s.add_dependency(%q<shindo>, ["~> 0.3"])
    end
  else
    s.add_dependency(%q<fog-core>, [">= 0"])
    s.add_dependency(%q<rbvmomi>, ["~> 1.8"])
    s.add_dependency(%q<bundler>, ["~> 1.10"])
    s.add_dependency(%q<pry>, ["~> 0.10"])
    s.add_dependency(%q<rake>, ["~> 10.0"])
    s.add_dependency(%q<rubocop>, ["~> 0.34"])
    s.add_dependency(%q<shindo>, ["~> 0.3"])
  end
end
