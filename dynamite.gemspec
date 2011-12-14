$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "dynamite/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "dynamite"
  s.version     = Dynamite::VERSION
  s.authors     = ["Jody Salt"]
  s.email       = ["jody@leanbid.com"]
  s.homepage    = "https://github.com/PS-Computer-Services-Ltd/dynamite/tree/master/lib"
  #s.summary     = "TODO: Summary of Dynamite."
  #s.description = "TODO: Description of Dynamite."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1.3"

  s.add_development_dependency "sqlite3"
end
