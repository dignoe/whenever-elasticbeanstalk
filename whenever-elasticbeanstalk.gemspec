# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'whenever-elasticbeanstalk/version'

Gem::Specification.new do |s|
  # Details
  s.name          = 'whenever-elasticbeanstalk'
  s.version       = Whenever::Elasticbeanstalk::VERSION
  s.platform      = Gem::Platform::RUBY
  s.date          = '2016-07-06'
  s.authors       = ['Chad McGimpsey', 'Joel Courtney', 'Taylor Boyko']
  s.email         = ['chad.mcgimpsey@gmail.com', 'euphemize@gmail.com', 'taylorboyko@gmail.com']
  s.description   = 'Use Whenever on AWS Elastic Beanstalk'
  s.summary       = 'Allows you to run cron jobs easily on one or all AWS Elastic Beanstalk instances.'
  s.homepage      = 'https://github.com/dignoe/whenever-elasticbeanstalk'
  s.license       = 'MIT'
  s.files         = Dir['lib/**/*', 'spec/**/*', 'test/**/*', 'features/**/*', 'bin/*']
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = %w(lib)

  # Dependencies
  s.add_dependency 'whenever', '~> 0.9.2'
  s.add_dependency 'aws-sdk', '~> 2.3'

  # Development / Test Dependencies
  s.add_development_dependency 'rspec', '~> 3.4', '>= 3.4.0'
  s.add_development_dependency 'rdoc', '~> 4.2', '>= 4.2.2'
  s.add_development_dependency 'jeweler', '~> 2.1', '>= 2.1.1'
  s.add_development_dependency 'simplecov', '~> 0.11', '>= 0.11.2'
  s.add_development_dependency 'coveralls', '~> 0.8', '>= 0.8.13'
  s.add_development_dependency 'awesome_print', '~> 1.7', '>= 1.7.0'
  s.add_development_dependency 'pry', '~> 0.10', '>= 0.10.3'
  s.add_development_dependency 'pry-nav', '~> 0.2', '>= 0.2.4'
  s.add_development_dependency 'webmock', '~> 2.1', '>= 2.1.0'
  s.add_development_dependency 'rubocop', '~> 0.41', '>= 0.41.1'
end
