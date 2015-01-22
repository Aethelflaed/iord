$:.push File.expand_path("../lib", __FILE__)

require 'iord/version'

Gem::Specification.new do |s|
  s.license     = 'MIT'
  s.name        = "iord"
  s.version     = Iord::VERSION
  s.authors     = ["Geoffroy Planquart"]
  s.email       = ["geoffroy@planquart.fr"]
  s.homepage    = "https://github.com/Aethelflaed/iord"
  s.summary     = "Information Oriented Representation of Data"
  s.description = "Easily create customizable CRUD based controllers with Information Oriented Representation of Data"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"].reject{|f| f[%r{^test/dummy/(tmp/|log/)}]}

  s.add_dependency 'rails', '~> 4.2'
  s.add_dependency 'mongoid', '~> 4.0'
  s.add_dependency 'nested_form', '~> 0.3'
end

