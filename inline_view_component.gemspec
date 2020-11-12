$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "inline_view_component/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name = "inline_view_component"
  spec.version = InlineViewComponent::VERSION
  spec.authors = ["Rafe Rosen"]
  spec.email = ["rafe@hey.com"]
  spec.homepage = "http://github.com/existentialmutt/inline_view_component"
  spec.summary = %q{Include template strings in Rails ViewComponent class definitions}
  spec.license = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", ">= 5"
  spec.add_dependency "activesupport", ">= 5.0.0"
  spec.add_dependency "view_component", "~> 2"

  spec.add_development_dependency "pg"
  spec.add_development_dependency "haml-rails"
  spec.add_development_dependency "standard"
end
