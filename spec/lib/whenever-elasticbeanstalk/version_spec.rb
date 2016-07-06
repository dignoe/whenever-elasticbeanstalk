require 'spec_helper'

describe Whenever::Elasticbeanstalk do
  describe 'version' do
    it 'has a version' do
      expect(Whenever::Elasticbeanstalk::VERSION).to be_a(String)
    end
  end
end
