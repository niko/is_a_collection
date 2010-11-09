# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)

Gem::Specification.new do |s|
  s.name         = "is_a_collection"
  s.version      = "0.0.1"
  s.authors      = ["Niko Dittmann"]
  s.email        = "mail@niko-dittmann.com"
  s.homepage     = "http://github.com/niko/is_a_collection"
  s.description  = "A small gem that adds #find and #all to a class to keep track of it's instances."
  s.summary      = s.description # for now
  
  s.files        = `git ls-files app lib`.split("\n")
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  
  s.add_development_dependency 'rspec'
end
