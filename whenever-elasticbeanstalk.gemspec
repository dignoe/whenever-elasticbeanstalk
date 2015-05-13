# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'whenever-elasticbeanstalk/version'

Gem::Specification.new do |gem|
  gem.name          = "whenever-elasticbeanstalk"
  gem.version       = Whenever::Elasticbeanstalk::VERSION
  gem.platform      = Gem::Platform::RUBY
  gem.authors       = ["Chad McGimpsey","Joel Courtney","Taylor Boyko"]
  gem.email         = ["chad.mcgimpsey@gmail.com","euphemize@gmail.com","taylorboyko@gmail.com"]
  gem.description   = %q{Use Whenever on AWS Elastic Beanstalk}
  gem.summary       = %q{Allows you to run cron jobs easily on one or all AWS Elastic Beanstalk instances.}
  gem.homepage      = "https://github.com/dignoe/whenever-elasticbeanstalk"
  gem.license       = 'MIT'

  gem.add_dependency('whenever','~> 0.9.2')
  gem.add_dependency('aws-sdk-v1', '>= 1.50.0')

  gem.files         = `git ls-files`.split($/)
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
