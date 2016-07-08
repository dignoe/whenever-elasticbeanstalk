require 'spec_helper'

describe Whenever::Elasticbeanstalk do
  describe 'instance methods' do
    it do
      expect(Whenever::Elasticbeanstalk.new(nil, eb_config_app_support: 'test')).to be_valid
    end

    describe '#region' do
      let(:whenever_elasticbeanstalk) { Whenever::Elasticbeanstalk.new(nil, eb_config_app_support: 'test') }
      it 'returns ap-southeast-1' do
        expect(whenever_elasticbeanstalk.region('ap-southeast-1a')).to eq('ap-southeast-1')
      end

      it 'returns ap-southeast-2' do
        expect(whenever_elasticbeanstalk.region('ap-southeast-2a')).to eq('ap-southeast-2')
      end

      it 'returns eu-central-1a' do
        expect(whenever_elasticbeanstalk.region('eu-central-1a')).to eq('eu-central-1')
      end
    end
  end
end
