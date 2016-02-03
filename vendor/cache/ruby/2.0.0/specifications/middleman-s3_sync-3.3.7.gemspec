# -*- encoding: utf-8 -*-
# stub: middleman-s3_sync 3.3.7 ruby lib

Gem::Specification.new do |s|
  s.name = "middleman-s3_sync"
  s.version = "3.3.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Frederic Jean", "Will Koehler"]
  s.date = "2015-12-04"
  s.description = "Only syncs files that have been updated to S3."
  s.email = ["fred@fredjean.net"]
  s.homepage = "http://github.com/fredjean/middleman-s3_sync"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.6"
  s.summary = "Tries really, really hard not to push files to S3."

  s.installed_by_version = "2.4.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<middleman-core>, ["~> 3.3"])
      s.add_runtime_dependency(%q<unf>, [">= 0"])
      s.add_runtime_dependency(%q<mime-types>, [">= 3.0"])
      s.add_runtime_dependency(%q<fog-aws>, [">= 0.7.0"])
      s.add_runtime_dependency(%q<map>, [">= 0"])
      s.add_runtime_dependency(%q<parallel>, [">= 0"])
      s.add_runtime_dependency(%q<ruby-progressbar>, [">= 0"])
      s.add_runtime_dependency(%q<ansi>, ["~> 1.5.0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<pry>, [">= 0"])
      s.add_development_dependency(%q<pry-byebug>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 3.0.0"])
      s.add_development_dependency(%q<rspec-its>, [">= 0"])
      s.add_development_dependency(%q<rspec-mocks>, [">= 0"])
      s.add_development_dependency(%q<timerizer>, [">= 0"])
      s.add_development_dependency(%q<travis>, [">= 0"])
      s.add_development_dependency(%q<travis-lint>, [">= 0"])
    else
      s.add_dependency(%q<middleman-core>, ["~> 3.3"])
      s.add_dependency(%q<unf>, [">= 0"])
      s.add_dependency(%q<mime-types>, [">= 3.0"])
      s.add_dependency(%q<fog-aws>, [">= 0.7.0"])
      s.add_dependency(%q<map>, [">= 0"])
      s.add_dependency(%q<parallel>, [">= 0"])
      s.add_dependency(%q<ruby-progressbar>, [">= 0"])
      s.add_dependency(%q<ansi>, ["~> 1.5.0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<pry>, [">= 0"])
      s.add_dependency(%q<pry-byebug>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 3.0.0"])
      s.add_dependency(%q<rspec-its>, [">= 0"])
      s.add_dependency(%q<rspec-mocks>, [">= 0"])
      s.add_dependency(%q<timerizer>, [">= 0"])
      s.add_dependency(%q<travis>, [">= 0"])
      s.add_dependency(%q<travis-lint>, [">= 0"])
    end
  else
    s.add_dependency(%q<middleman-core>, ["~> 3.3"])
    s.add_dependency(%q<unf>, [">= 0"])
    s.add_dependency(%q<mime-types>, [">= 3.0"])
    s.add_dependency(%q<fog-aws>, [">= 0.7.0"])
    s.add_dependency(%q<map>, [">= 0"])
    s.add_dependency(%q<parallel>, [">= 0"])
    s.add_dependency(%q<ruby-progressbar>, [">= 0"])
    s.add_dependency(%q<ansi>, ["~> 1.5.0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<pry>, [">= 0"])
    s.add_dependency(%q<pry-byebug>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 3.0.0"])
    s.add_dependency(%q<rspec-its>, [">= 0"])
    s.add_dependency(%q<rspec-mocks>, [">= 0"])
    s.add_dependency(%q<timerizer>, [">= 0"])
    s.add_dependency(%q<travis>, [">= 0"])
    s.add_dependency(%q<travis-lint>, [">= 0"])
  end
end
