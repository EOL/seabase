require "set"
require "ostruct"
require "yaml"
require "active_record"
require "csv"
require "fileutils"
require "nokogiri"

# All encompassing module for the project
module Seabase
  def self.env
    @env ||= ENV["SEABASE_ENV"] ? ENV["SEABASE_ENV"].to_sym : :development
  end

  def self.env=(env)
    if [:development, :test, :production].include?(env)
      @env = env
    else
      fail TypeError, "Wrong environment"
    end
  end

  def self.db_conf
    @db_conf ||= new_db_conf
  end

  def self.conf
    @conf ||= new_conf
  end

  def self.db_connection
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Base.logger.level = Logger::WARN
    ActiveRecord::Base.establish_connection(db_conf[env.to_s])
  end

  private

  def self.new_db_conf
    @db_conf = new_conf.database
  end

  def self.new_conf
    raw_conf = File.read(File.join(__dir__, "config", "database.yml"))
    conf = YAML.load(ERB.new(raw_conf).result)
    OpenStruct.new(
      ga_id: ENV["GOOGLE_ANALYTICS_ID"] || "123_abc",
      ga_domain: ENV["GOOGLE_ANALYTICS_DOMAIN"] || "example.org",
      session_secret: ENV["SESSION_SECRET"] || "change_me",
      database: conf
     )
  end
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "models"))
Dir.glob(File.join(File.dirname(__FILE__), "models", "**", "*.rb")) do |app|
  require File.basename(app, ".*")
end

Seabase.db_connection
