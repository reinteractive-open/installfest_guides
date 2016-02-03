# -*- encoding: utf-8 -*-
# stub: fog-aliyun 0.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "fog-aliyun"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Qinsi Deng, Jianxun Li, Jane Han"]
  s.bindir = "exe"
  s.date = "2015-11-07"
  s.description = "As a FOG provider, fog-aliyun support aliyun OSS/ECS. It will support more aliyun services later."
  s.email = ["dengqs@dtdream.com"]
  s.homepage = "https://github.com/fog/fog-aliyun"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.6"
  s.summary = "Fog provider for Aliyun Web Services."

  s.installed_by_version = "2.4.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, ["~> 1.10"])
      s.add_development_dependency(%q<rake>, ["~> 10.0"])
      s.add_development_dependency(%q<rspec>, ["~> 3.3"])
      s.add_runtime_dependency(%q<fog-core>, ["~> 1.27"])
      s.add_runtime_dependency(%q<fog-json>, ["~> 1.0"])
      s.add_runtime_dependency(%q<ipaddress>, ["~> 0.8"])
      s.add_runtime_dependency(%q<xml-simple>, ["~> 1.1"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.10"])
      s.add_dependency(%q<rake>, ["~> 10.0"])
      s.add_dependency(%q<rspec>, ["~> 3.3"])
      s.add_dependency(%q<fog-core>, ["~> 1.27"])
      s.add_dependency(%q<fog-json>, ["~> 1.0"])
      s.add_dependency(%q<ipaddress>, ["~> 0.8"])
      s.add_dependency(%q<xml-simple>, ["~> 1.1"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.10"])
    s.add_dependency(%q<rake>, ["~> 10.0"])
    s.add_dependency(%q<rspec>, ["~> 3.3"])
    s.add_dependency(%q<fog-core>, ["~> 1.27"])
    s.add_dependency(%q<fog-json>, ["~> 1.0"])
    s.add_dependency(%q<ipaddress>, ["~> 0.8"])
    s.add_dependency(%q<xml-simple>, ["~> 1.1"])
  end
end
