require 'coveralls'
Coveralls.wear!

require 'rack/test'
require 'webmock/rspec'

ENV['SEABASE_ENV'] = 'test'
require_relative '../application.rb'

module RSpecMixin
  include Rack::Test::Methods
  def app() SeabaseApp end
end

RSpec.configure do |c|
  c.include RSpecMixin
end

