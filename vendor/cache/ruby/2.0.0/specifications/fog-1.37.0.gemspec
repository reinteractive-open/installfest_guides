# -*- encoding: utf-8 -*-
# stub: fog 1.37.0 ruby lib

Gem::Specification.new do |s|
  s.name = "fog"
  s.version = "1.37.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["geemus (Wesley Beary)"]
  s.date = "2015-12-22"
  s.description = "The Ruby cloud services library. Supports all major cloud providers including AWS, Rackspace, Linode, Blue Box, StormOnDemand, and many others. Full support for most AWS services including EC2, S3, CloudWatch, SimpleDB, ELB, and RDS."
  s.email = "geemus@gmail.com"
  s.executables = ["fog"]
  s.extra_rdoc_files = ["README.md"]
  s.files = ["README.md", "bin/fog"]
  s.homepage = "http://github.com/fog/fog"
  s.licenses = ["MIT"]
  s.rdoc_options = ["--charset=UTF-8"]
  s.rubyforge_project = "fog"
  s.rubygems_version = "2.4.6"
  s.summary = "brings clouds to you"

  s.installed_by_version = "2.4.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 2

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<fog-core>, ["~> 1.32"])
      s.add_runtime_dependency(%q<fog-json>, [">= 0"])
      s.add_runtime_dependency(%q<fog-xml>, ["~> 0.1.1"])
      s.add_runtime_dependency(%q<ipaddress>, ["~> 0.5"])
      s.add_runtime_dependency(%q<fog-atmos>, [">= 0"])
      s.add_runtime_dependency(%q<fog-aws>, [">= 0.6.0"])
      s.add_runtime_dependency(%q<fog-brightbox>, ["~> 0.4"])
      s.add_runtime_dependency(%q<fog-dynect>, ["~> 0.0.2"])
      s.add_runtime_dependency(%q<fog-ecloud>, ["~> 0.1"])
      s.add_runtime_dependency(%q<fog-google>, ["<= 0.1.0"])
      s.add_runtime_dependency(%q<fog-local>, [">= 0"])
      s.add_runtime_dependency(%q<fog-powerdns>, [">= 0.1.1"])
      s.add_runtime_dependency(%q<fog-profitbricks>, [">= 0"])
      s.add_runtime_dependency(%q<fog-radosgw>, [">= 0.0.2"])
      s.add_runtime_dependency(%q<fog-riakcs>, [">= 0"])
      s.add_runtime_dependency(%q<fog-sakuracloud>, [">= 0.0.4"])
      s.add_runtime_dependency(%q<fog-serverlove>, [">= 0"])
      s.add_runtime_dependency(%q<fog-softlayer>, [">= 0"])
      s.add_runtime_dependency(%q<fog-storm_on_demand>, [">= 0"])
      s.add_runtime_dependency(%q<fog-terremark>, [">= 0"])
      s.add_runtime_dependency(%q<fog-vmfusion>, [">= 0"])
      s.add_runtime_dependency(%q<fog-voxel>, [">= 0"])
      s.add_runtime_dependency(%q<fog-vsphere>, [">= 0.4.0"])
      s.add_runtime_dependency(%q<fog-xenserver>, [">= 0"])
      s.add_runtime_dependency(%q<fog-aliyun>, [">= 0.1.0"])
      s.add_development_dependency(%q<docker-api>, [">= 1.13.6"])
      s.add_development_dependency(%q<fission>, [">= 0"])
      s.add_development_dependency(%q<mime-types>, [">= 0"])
      s.add_development_dependency(%q<minitest>, [">= 0"])
      s.add_development_dependency(%q<minitest-stub-const>, [">= 0"])
      s.add_development_dependency(%q<opennebula>, [">= 0"])
      s.add_development_dependency(%q<pry>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rbovirt>, ["= 0.0.32"])
      s.add_development_dependency(%q<rbvmomi>, [">= 0"])
      s.add_development_dependency(%q<rubocop>, [">= 0"])
      s.add_development_dependency(%q<shindo>, ["~> 0.3.4"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
      s.add_development_dependency(%q<thor>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
      s.add_development_dependency(%q<rspec-core>, [">= 0"])
      s.add_development_dependency(%q<rspec-expectations>, [">= 0"])
      s.add_development_dependency(%q<vcr>, [">= 0"])
      s.add_development_dependency(%q<webmock>, ["~> 1.22.2"])
    else
      s.add_dependency(%q<fog-core>, ["~> 1.32"])
      s.add_dependency(%q<fog-json>, [">= 0"])
      s.add_dependency(%q<fog-xml>, ["~> 0.1.1"])
      s.add_dependency(%q<ipaddress>, ["~> 0.5"])
      s.add_dependency(%q<fog-atmos>, [">= 0"])
      s.add_dependency(%q<fog-aws>, [">= 0.6.0"])
      s.add_dependency(%q<fog-brightbox>, ["~> 0.4"])
      s.add_dependency(%q<fog-dynect>, ["~> 0.0.2"])
      s.add_dependency(%q<fog-ecloud>, ["~> 0.1"])
      s.add_dependency(%q<fog-google>, ["<= 0.1.0"])
      s.add_dependency(%q<fog-local>, [">= 0"])
      s.add_dependency(%q<fog-powerdns>, [">= 0.1.1"])
      s.add_dependency(%q<fog-profitbricks>, [">= 0"])
      s.add_dependency(%q<fog-radosgw>, [">= 0.0.2"])
      s.add_dependency(%q<fog-riakcs>, [">= 0"])
      s.add_dependency(%q<fog-sakuracloud>, [">= 0.0.4"])
      s.add_dependency(%q<fog-serverlove>, [">= 0"])
      s.add_dependency(%q<fog-softlayer>, [">= 0"])
      s.add_dependency(%q<fog-storm_on_demand>, [">= 0"])
      s.add_dependency(%q<fog-terremark>, [">= 0"])
      s.add_dependency(%q<fog-vmfusion>, [">= 0"])
      s.add_dependency(%q<fog-voxel>, [">= 0"])
      s.add_dependency(%q<fog-vsphere>, [">= 0.4.0"])
      s.add_dependency(%q<fog-xenserver>, [">= 0"])
      s.add_dependency(%q<fog-aliyun>, [">= 0.1.0"])
      s.add_dependency(%q<docker-api>, [">= 1.13.6"])
      s.add_dependency(%q<fission>, [">= 0"])
      s.add_dependency(%q<mime-types>, [">= 0"])
      s.add_dependency(%q<minitest>, [">= 0"])
      s.add_dependency(%q<minitest-stub-const>, [">= 0"])
      s.add_dependency(%q<opennebula>, [">= 0"])
      s.add_dependency(%q<pry>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rbovirt>, ["= 0.0.32"])
      s.add_dependency(%q<rbvmomi>, [">= 0"])
      s.add_dependency(%q<rubocop>, [">= 0"])
      s.add_dependency(%q<shindo>, ["~> 0.3.4"])
      s.add_dependency(%q<simplecov>, [">= 0"])
      s.add_dependency(%q<thor>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0"])
      s.add_dependency(%q<rspec-core>, [">= 0"])
      s.add_dependency(%q<rspec-expectations>, [">= 0"])
      s.add_dependency(%q<vcr>, [">= 0"])
      s.add_dependency(%q<webmock>, ["~> 1.22.2"])
    end
  else
    s.add_dependency(%q<fog-core>, ["~> 1.32"])
    s.add_dependency(%q<fog-json>, [">= 0"])
    s.add_dependency(%q<fog-xml>, ["~> 0.1.1"])
    s.add_dependency(%q<ipaddress>, ["~> 0.5"])
    s.add_dependency(%q<fog-atmos>, [">= 0"])
    s.add_dependency(%q<fog-aws>, [">= 0.6.0"])
    s.add_dependency(%q<fog-brightbox>, ["~> 0.4"])
    s.add_dependency(%q<fog-dynect>, ["~> 0.0.2"])
    s.add_dependency(%q<fog-ecloud>, ["~> 0.1"])
    s.add_dependency(%q<fog-google>, ["<= 0.1.0"])
    s.add_dependency(%q<fog-local>, [">= 0"])
    s.add_dependency(%q<fog-powerdns>, [">= 0.1.1"])
    s.add_dependency(%q<fog-profitbricks>, [">= 0"])
    s.add_dependency(%q<fog-radosgw>, [">= 0.0.2"])
    s.add_dependency(%q<fog-riakcs>, [">= 0"])
    s.add_dependency(%q<fog-sakuracloud>, [">= 0.0.4"])
    s.add_dependency(%q<fog-serverlove>, [">= 0"])
    s.add_dependency(%q<fog-softlayer>, [">= 0"])
    s.add_dependency(%q<fog-storm_on_demand>, [">= 0"])
    s.add_dependency(%q<fog-terremark>, [">= 0"])
    s.add_dependency(%q<fog-vmfusion>, [">= 0"])
    s.add_dependency(%q<fog-voxel>, [">= 0"])
    s.add_dependency(%q<fog-vsphere>, [">= 0.4.0"])
    s.add_dependency(%q<fog-xenserver>, [">= 0"])
    s.add_dependency(%q<fog-aliyun>, [">= 0.1.0"])
    s.add_dependency(%q<docker-api>, [">= 1.13.6"])
    s.add_dependency(%q<fission>, [">= 0"])
    s.add_dependency(%q<mime-types>, [">= 0"])
    s.add_dependency(%q<minitest>, [">= 0"])
    s.add_dependency(%q<minitest-stub-const>, [">= 0"])
    s.add_dependency(%q<opennebula>, [">= 0"])
    s.add_dependency(%q<pry>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rbovirt>, ["= 0.0.32"])
    s.add_dependency(%q<rbvmomi>, [">= 0"])
    s.add_dependency(%q<rubocop>, [">= 0"])
    s.add_dependency(%q<shindo>, ["~> 0.3.4"])
    s.add_dependency(%q<simplecov>, [">= 0"])
    s.add_dependency(%q<thor>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0"])
    s.add_dependency(%q<rspec-core>, [">= 0"])
    s.add_dependency(%q<rspec-expectations>, [">= 0"])
    s.add_dependency(%q<vcr>, [">= 0"])
    s.add_dependency(%q<webmock>, ["~> 1.22.2"])
  end
end
