#!/usr/bin/env ruby

require 'zen-grids'
require 'rack/timeout'
require 'sinatra'
require 'sinatra/base'
require 'haml'
require 'sass'
require 'childprocess'

require_relative 'lib/seabase'
require_relative 'lib/rack/blast'
require_relative 'routes'
require_relative 'helpers'

configure do
  use Rack::MethodOverride
  use Rack::Session::Cookie, secret: Seabase.conf.session_secret
  use Rack::Blast
  use Rack::Timeout
  Rack::Timeout.timeout = 9_000_000

  Compass.add_project_configuration(File.join(File.dirname(__FILE__),  
                                              'config', 
                                              'compass.config'))    
  set :scss, Compass.sass_engine_options
end

