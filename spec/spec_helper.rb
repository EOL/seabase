require 'coveralls'
Coveralls.wear!

# HACK: to suppress warnings                                                     
$VERBOSE = nil   

require 'rack/test'
require 'webmock/rspec'
require 'capybara'
require 'capybara/dsl'

ENV['SEABASE_ENV'] = 'test'
require_relative '../application.rb'

Capybara.app = SeabaseApp

RSpec.configure do |c|
  c.include Capybara
end

