require 'spec_helper'

describe Whenever::Elasticbeanstalk do
  describe 'instance methods' do
    it do
      expect(Whenever::Elasticbeanstalk.new(nil, eb_config_app_support: 'test')).to be_valid
    end
  end
end
