$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "iord/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "iord"
  s.version     = Iord::VERSION
  s.authors     = ["Geoffroy Planquart"]
  s.email       = ["geoffroy@planquart.fr"]
  s.homepage    = "https://github.com/Aethelflaed/iord"
  s.summary     = "Information Oriented Representation of Data"
  s.description = "Easily create customizable CRUD based controllers with Information Oriented Representation of Data"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.2"

  s.add_development_dependency 'nested_form', '~> 0.3.2'
  s.add_development_dependency 'factory_girl_rails'
  s.add_runtime_dependency 'nested_form', '~> 0.3.2'
end
