# Whenever::Elasticbeanstalk

Whenever-elasticbeanstalk is an extension gem to [Whenever](https://github.com/javan/whenever) that automatically ensures that one instance in an AWS Elastic Beanstalk environment is set as leader. This allows you to run cron jobs on all instances, or just on the leader. This is required since Elastic Beanstalk may start or stop any instance as it scales up or down.

## Installation

**Whenever-elasticbeanstalk is still under development and not packaged as a gem yet**

Add this line to your application's Gemfile:

    gem 'whenever-elasticbeanstalk'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install whenever-elasticbeanstalk

## Getting started

		$ cd /apps/my-great-project
		$ wheneverize-eb .

This will create an initial `config/schedule.rb` file for you with the `ensure_leader` job set to run every minute. It will also create a `.ebextensions/cron.config` file that will automatically choose a leader on environment initialization, and start up Whenever with the correct `leader` role.

## Usage

For `config/schedule.rb` usage, please see the documentation for the [Whenever gem](https://github.com/javan/whenever).

### Run a task on only one instance

To run a task only on one instance, assign the task to the `leader` role.

		every :day, :at => "12:30am", :roles => [:leader] do
			runner "MyModel.task_to_run_nightly_only_on_one_instance"
		end

### Run a task on all instances

To run a task on all instance, omit the `roles` option.

		every 1.minute do
			command "touch /opt/elasticbeanstalk/support/.cron_check"
		end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
