# -*- encoding: utf-8 -*-
# stub: markdown-rails 0.2.1 ruby lib

Gem::Specification.new do |s|
  s.name = "markdown-rails"
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Jo Liss"]
  s.date = "2012-08-16"
  s.description = "Markdown as a static templating language for Rails views and partials"
  s.email = ["joliss42@gmail.com"]
  s.homepage = "https://github.com/joliss/markdown-rails"
  s.rubygems_version = "2.4.7"
  s.summary = "Markdown as a Rails templating language"

  s.installed_by_version = "2.4.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, [">= 0"])
      s.add_runtime_dependency(%q<rdiscount>, ["< 2.0", ">= 1.6.8"])
    else
      s.add_dependency(%q<rails>, [">= 0"])
      s.add_dependency(%q<rdiscount>, ["< 2.0", ">= 1.6.8"])
    end
  else
    s.add_dependency(%q<rails>, [">= 0"])
    s.add_dependency(%q<rdiscount>, ["< 2.0", ">= 1.6.8"])
  end
end
