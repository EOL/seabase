require 'ostruct'
require 'yaml'
require 'active_record'
require 'csv'
require 'fileutils'
require 'nokogiri'

module Seabase

  def self.env
    @env ||= ENV['SEABASE_ENV'] ? ENV['SEABASE_ENV'].to_sym : :development
  end

  def self.env=(env)
    if [:development, :test, :production].include?(env)
      @env = env
    else
      raise TypeError.new('Wrong environment')
    end
  end

  def self.db_conf
    @db_conf ||= get_db_conf
  end

  def self.conf
    @conf ||= get_conf
  end

  def self.get_db_connection
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Base.logger.level = Logger::WARN
    ActiveRecord::Base.establish_connection(db_conf[env.to_s])
  end

  private

  def self.get_db_conf
    @db_conf = get_conf.database
  end

  def self.get_conf
    raw_conf = File.read(File.join(File.dirname(__FILE__),
                         'config', 'config.yml'))
    conf = YAML.load(raw_conf)
    OpenStruct.new(
      ga_id:            conf['google_analytics_id'],
      ga_domain:        conf['google_analytics_domain'],
      session_secret:   conf['session_secret'],
      database:         conf['database'],
     )
  end
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'models'))
Dir.glob(File.join(File.dirname(__FILE__), 'models', '**', '*.rb')) do |app|
  require File.basename(app, '.*')
end


Seabase.get_db_connection

