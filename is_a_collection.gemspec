# encoding: utf-8

Gem::Specification.new do |s|
  s.name         = 'is_a_collection'
  s.version      = '0.1.1'
  s.authors      = ['Niko Dittmann']
  s.email        = 'mail@niko-dittmann.com'
  s.homepage     = 'http://github.com/niko/is_a_collection'
  s.description  = 'A small gem that adds #find, #all and #destroy to a class to keep track of its instances.'
  s.summary      = s.description # for now
  
  s.files        = Dir['lib/**/*.rb']
  s.test_files   = Dir['spec/**/*_spec.rb']
  
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  
  s.rubyforge_project = 'nowarning'
  s.add_development_dependency 'rspec'
end
