# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_sendwithus'
  s.version     = '2.0.11'
  s.summary     = 'SendWithUs integration'
  s.required_ruby_version = '>= 1.9.3'

  s.author    = 'FreeRunning Technologies'
  s.email     = 'contact@freerunningtech.com'
  s.homepage  = 'http://www.freerunningtech.com'

  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 2.0.11.beta'
  s.add_dependency 'send_with_us', '~> 1.1.4'

  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'rspec-rails', '~> 3.0.0'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
end
