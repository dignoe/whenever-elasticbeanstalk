# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'whenever-elasticbeanstalk/version'

Gem::Specification.new do |gem|
  gem.name          = "whenever-elasticbeanstalk"
  gem.version       = Whenever::Elasticbeanstalk::VERSION
  gem.authors       = ["Chad McGimpsey"]
  gem.email         = ["chad.mcgimpsey@gmail.com"]
  gem.description   = %q{Use whenever on AWS Elastic Beanstalk}
  gem.summary       = %q{Allows you to run cron jobs easily on one or all AWS Elastic Beanstalk instances.}
  gem.homepage      = "https://github.com/dignoe/whenever-elasticbeanstalk"

  gem.add_dependency('whenever')
  gem.add_dependency('aws-sdk')

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
