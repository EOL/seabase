ENV['SEABASE_ENV'] = (ENV['RACK_ENV'] || 'development')
require './application.rb'

set :run, false

use ActiveRecord::ConnectionAdapters::ConnectionManagement

run Sinatra::Application
