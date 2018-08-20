$:.push File.expand_path("../lib", __FILE__)

require "vlad-unity/version"

Gem::Specification.new do |s|
  s.name        = "vlad-unity"
  s.version     = VladUnity::VERSION
  s.authors     = ["Matt Smith"]
  s.email       = ["matt@nearapogee.com"]
  s.homepage    = "https://github.com/nearapogee/vlad-unity"
  s.summary     = "A (hopefully) more agnostic set of vlad extensions."
  s.description = "General vlad utilities."
  s.license     = "MIT"

  s.files = Dir["{lib}/**/*", "MIT-LICENSE", "README.md"]

  s.add_dependency "vlad", ">= 2.0.0"
end
