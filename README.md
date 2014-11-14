# WARNING
AWS has recently made changes to their EB ENV variables that are catastrophic for much of the rails deployment approaches for EB. This includes whenever-elasticbeanstalk. We are investigating how we can address these issues. Please see [Issue 18](https://github.com/dignoe/whenever-elasticbeanstalk/issues/18) for further details. Will update when a resolution is available.

# Whenever::Elasticbeanstalk

Whenever-elasticbeanstalk is an extension gem to [Whenever](https://github.com/javan/whenever) that automatically ensures that one instance in an AWS Elastic Beanstalk environment is set as leader. This allows you to run cron jobs on all instances, or just on the leader. This is required since Elastic Beanstalk may start or stop any instance as it scales up or down.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'whenever-elasticbeanstalk'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install whenever-elasticbeanstalk
```

## Getting started
```bash
$ cd /apps/my-great-project
$ wheneverize-eb .
```

This will create an initial `config/schedule.rb` file for you with the `ensure_leader` job set to run every minute. It will also create a `.ebextensions/cron.config` file that will automatically choose a leader on environment initialization, and start up Whenever with the correct `leader` role. Lastly, it creates the `config/whenever-elasticbeanstalk.yml` file that will contain your AWS credentials for retrieving your environment information.

### Manually updating schedule

If you are already using Whenever, running `wheneverize-eb .` won't overwrite your `config/schedule.rb` file. You'll need to add the following lines in order for your environment to always have one leader.

```ruby
every 1.minute do
  command "cd /var/app/current && bundle exec ensure_one_cron_leader"
end
```

### EC2 Instance IAM Role Permissions

In order for the scripts to work, you need to ensure that the EC2 Instance Role has access to EC2 instances and tags (further reading at [AWS Documentation](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/AWSHowTo.iam.roles.aeb.html) ). Ensure that your EC2 instance has at a minimum the following permissions:

Example policy:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:DescribeInstanceAttribute",
        "ec2:DescribeInstanceStatus",
        "ec2:DescribeInstances",
        "ec2:DescribeTags",
        "ec2:CreateTags"
      ],
      "Resource": [
        "*"
      ],
      "Effect": "Allow"
    }
  ]
}
```

Make sure to add the `RACK_ENV` environment variable to your environment if you haven't already done so. This variable is not created automatically by AWS. You can add the following line to your `.elasticbeanstalk/optionsettings.appname-env` file:
```yaml
RACK_ENV=staging
```

## Usage

For `config/schedule.rb` usage, please see the documentation for the [Whenever gem](https://github.com/javan/whenever).

### Run a task on only one instance

To run a task only on one instance, assign the task to the `leader` role.
```ruby
every :day, :at => "12:30am", :roles => [:leader] do
	runner "MyModel.task_to_run_nightly_only_on_one_instance"
end
```

### Run a task on all instances

To run a task on all instance, omit the `roles` option.
```ruby
every 1.minute do
	command "touch $EB_CONFIG_APP_SUPPORT/.cron_check"
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
