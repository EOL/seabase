require 'coveralls'
Coveralls.wear!

# HACK: to suppress warnings                                                     
$VERBOSE = nil   

require 'rack/test'
require 'capybara'
require 'capybara/rspec'
require 'capybara/dsl'
require 'capybara/webkit'

ENV['SEABASE_ENV'] = 'test'
require_relative '../application.rb'

Capybara.javascript_driver = :webkit
Capybara.app = Sinatra::Application

RSpec.configure do |c|
  c.include Capybara::DSL
end

class Float
  def absolute_approx(other, epsilon=Float::EPSILON)
    return (other-self).abs <= epsilon
  end
end

def near_enough(a1, a2)
  if a1.class == Array
    a1.zip(a2).map {|r1, r2| near_enough(r1, r2)}.reduce(:&)
  elsif a1.class == Float
    a1.absolute_approx(a2)
  else
    a1 == a2
  end
end

def os
  res = 'linux'
  res = 'win' if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM)
  res = 'mac' if (/darwin/ =~ RUBY_PLATFORM) 
  res
end

def login_as_admin
  visit '/login'
  fill_in 'login_email', with: 'jane.doe@example.org'
  fill_in 'login_password', with: 'secret'
  click_button 'login_submit'
end
