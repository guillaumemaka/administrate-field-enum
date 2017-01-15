$LOAD_PATH.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |gem|
  gem.name = "administrate-field-enum"
  gem.version = "0.0.1"
  gem.authors = ["Guillaume Maka"]
  gem.email = ["guillaume.maka@gmail.com"]
  gem.homepage = "https://github.com/guillaumemaka/administrate-field-enum"
  gem.summary = "Unofficial Enum field plugin for Administrate"
  gem.description = gem.summary
  gem.license = "MIT"

  gem.require_paths = ["lib"]
  gem.files = `git ls-files`.split("\n")
  gem.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")

  gem.add_dependency "administrate", ">= 0.2.0.rc1"
  gem.add_dependency "appraisal", "~> 2.1"
  gem.add_dependency "rails", ">= 4.2"

  gem.add_development_dependency "rspec", "~> 3.4"
end
