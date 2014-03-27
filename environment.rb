require 'ostruct'
require 'yaml'
require 'active_record'
require 'csv'
require 'fileutils'

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
    @db_conf ||= self.get_db_conf
  end

  def self.conf
    @conf ||= self.get_conf
  end

  def self.get_db_connection
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Base.logger.level = Logger::WARN
    ActiveRecord::Base.establish_connection(self.db_conf[self.env.to_s])
  end

  private

  def self.get_db_conf
    conf = File.read(File.join(File.dirname(__FILE__),
                          'config', 'config.yml'))
    @db_conf = YAML.load(conf)
  end

  def self.get_conf
    conf = self.db_conf[self.env.to_s]
    @conf = OpenStruct.new(
                            ga_id:            conf['google_analytics_id'],
                            ga_domain:        conf['google_analytics_domain'],
                            session_secret:   conf['session_secret'],
                            adapter:          conf['adapter'],
                            host:             conf['host'],
                            username:         conf['username'],
                            password:         conf['password'],
                            database:         conf['database'],
                           )
  end
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'models'))
Dir.glob(File.join(File.dirname(__FILE__), 'models', '**', '*.rb')) do |app|
  require File.basename(app, '.*')
end


Seabase.get_db_connection

