require 'rubygems'
require 'aws-sdk'
require 'whenever'
require 'whenever-elasticbeanstalk/version'

module Whenever
  # [Whenever::Elasticbeanstalk]
  #
  # @since 0.1.0
  # @note Overhauled in 1.2.0 to add in functionality for
  class Elasticbeanstalk
    # @!group Class Constants
    ENVIRONMENT = ENV['RACK_ENV'].freeze
    ENVIRONMENT_NAME_TAG = 'elasticbeanstalk:environment-name'.freeze
    # @!endgroup

    # @!group Instance Methods
    # Initializes a new Whenever::Elasticbeanstalk
    #
    # @param [Aws::CredentialProvider] credentials
    # @param [Hash] options
    # @options options [String] :eb_config_app_support
    # @return [self]
    def initialize(credentials, options = {})
      defaults = { eb_config_app_support: '/var/app/containerfiles' }
      options = defaults.merge(options)

      @credentials = credentials
      @config_app_support = options[:eb_config_app_support]
      @instance_id = instance_id
      @availability_zone = `/opt/aws/bin/ec2-metadata -z | awk '{print $2}'`.strip
      @region = region(@availability_zone)

      @ec2_resource = Aws::EC2::Resource.new(region: @region, credentials: @credentials)
      @environment_name = environment_name
    end

    # Returns the AWS Region based on the availability_zone
    #
    # @param [String] availability_zone
    # @return [String]
    def region(availability_zone)
      availability_zone.match(/^(([a-z]{2}\-[a-z]+\-\d)[a-z])$/)[2]
    end

    # Returns the current EC2 instance's id
    #
    # @return [String] current Aws::EC2::Instance#id
    def instance_id
      filename = File.join(@config_app_support, 'instance_id')
      if File.exist?(filename)
        File.read(filename)
      elsif (id = `/opt/aws/bin/ec2-metadata -i | awk '{print $2}'`.strip)
        File.open(filename, 'w') { |f| f.write(id) }
        id
      end
    end

    # Returns an Aws::EC2::Instance for the current EC2 instance
    #
    # @return [Aws::EC2::Instance] current Aws::EC2::Instance
    def instance
      @ec2_resource.instance(instance_id)
    end

    # Instances in the application
    #
    # @return [Array<Aws::EC2::Instance>]
    def instances
      filters = [
        { name: "tag:#{ENVIRONMENT_NAME_TAG}", values: [@environment_name] },
        { name: 'instance-state-name', values: ['running'] }
      ]

      @ec2_resource.instances(filters: filters).each_with_object([]) do |i, m|
        m << i.id
      end
    end

    # Leader Instances in the application
    #
    # @return [Array<Aws::EC2::Instance>]
    def leader_instances
      filters = [
        { name: "tag:#{ENVIRONMENT_NAME_TAG}", values: [@environment_name] },
        { name: 'tag:leader', values: ['true'] },
        { name: 'instance-state-name', values: ['running'] }
      ]

      @ec2_resource.instances(filters: filters).each_with_object([]) do |i, m|
        m << i.id
      end
    end

    # Determines the Environment Name from the tag 'elasticbeanstalk:environment-name'
    # Writes to ENVIRONMENT_NAME_FILE
    #
    # @return [String] description of returned object
    def environment_name
      filename = File.join(@config_app_support, 'env_name')
      if File.exist?(filename)
        File.read(filename)
      else
        ec2_instance = @ec2_resource.instance(@instance_id)
        env_name_tag = ec2_instance.tags.find { |t| t.key == ENVIRONMENT_NAME_TAG }
        File.open(filename, 'w') { |f| f.write(env_name_tag.value) }
        env_name_tag.value
      end
    end

    # Creates a CRON Leader Instance if there is none set
    #
    # @param [Hash] options = {}
    # @option options [Boolean] :no_update
    # @return [void]
    def create_cron_leader(options = {})
      self.leader_tag = 'true' if leader_instances.empty?

      setup_cron unless options[:no_update]
    end

    # Removes CRON leaders if more than one present
    #
    # @return [void]
    def ensure_one_cron_leader
      if leader_instances.empty?
        create_cron_leader
      elsif leader_instances.count > 1 && leader_instances.include?(@instance_id)
        self.leader_tag = 'false'
        setup_cron
      end
    end

    # Removes Instance from CRON leaders if more than one present
    # Then sets up the cron
    #
    # @return [void]
    def remove_cron_leader
      if leader_instances.count > 1 && leader_instances.include?(@instance_id)
        self.leader_tag = 'false'
      end
      setup_cron
    end

    # Sets up the CRON tasks
    #
    # @return [void]
    def setup_cron
      # Set the PATH
      unless `echo $PATH`.strip.split(':').include?('/usr/local/bin')
        `export PATH=/usr/local/bin:$PATH`
      end

      roles = [ENV['RACK_ENV'], (leader? ? 'leader' : 'non-leader')]

      # Command parts
      command_prefix = 'bundle exec whenever'
      command_suffix = "--set 'environment=#{ENV['RACK_ENV']}&path=/var/app/current' " \
                       '--update-crontab'
      command_roles = "--roles #{roles.compact.join(',')}"

      # Build the command
      command = [command_prefix, command_roles, command_suffix].join(' ')

      # Run the command
      `#{command}`
    end

    # Set the leader tag to something
    #
    # @param [String, Boolean] value
    # @return [void]
    def leader_tag=(value)
      tags = [{ key: 'leader', value: value.to_s }]
      @ec2_resource.create_tags(resources: [@instance_id], tags: tags)
    end

    # Is the instance a leader?
    #
    # @return [Boolean]
    def leader?
      leader_tag = instance.tags.find { |t| t.key == 'leader' }
      !leader_tag.nil? && (leader_tag.value.casecmp('true') == 0)
    end
    # @!endgroup
  end
end
