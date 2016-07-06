require 'coveralls'
require 'simplecov'
require 'pry'
require 'webmock/rspec'
require 'whenever-elasticbeanstalk'

WebMock.disable_net_connect!(allow_localhost: true)

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
  [
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]
)
SimpleCov.start

RSpec.configure do |config|
  # WebMock
  config.before(:each) do
    csv_headers = { 'Content-Type' => 'text/csv' }
    xml_headers = { 'Content-Type' => 'text/xml' }

  end

  config.order = 'random'
end

def fixture(filename)
  path = "#{File.dirname(__FILE__)}/fixtures/#{filename}"
  File.open(path)
end
