require 'bundler'
require 'active_record'
require 'rake'
require 'rspec'
require 'rspec/core/rake_task'
require_relative 'environment'

task :default => :spec

RSpec::Core::RakeTask.new do |t|
  t.pattern = 'spec/**/*spec.rb'
end

include ActiveRecord::Tasks

conf = YAML.load(File.read('config/config.yml'))
ActiveRecord::Base.configurations = conf
DatabaseTasks.db_dir = 'db'


# usage: rake generate:migration[name_of_migration]
namespace :generate do
  task(:migration, :migration_name) do |t, args|
    timestamp = Time.now.gmtime.to_s[0..18].gsub(/[^\d]/, '')
    migration_name = args[:migration_name]
    file_name = "%s_%s.rb" % [timestamp, migration_name]
    class_name = migration_name.split("_").map {|w| w.capitalize}.join('')
    path = File.join(File.expand_path(File.dirname(__FILE__)), 
                     'db', 'migrate', file_name)
    f = open(path, 'w')
    content = "class #{class_name} < ActiveRecord::Migration
  def up
  end
  
  def down
  end
end
"
    f.write(content)
    puts "Generated migration %s" % path
    f.close
 end
end

namespace :db do
  namespace :create do
    task(:all) do
      DatabaseTasks.create_all
    end
  end

  namespace :drop do
    task(:all) do
      DatabaseTasks.drop_all
    end
  end
  
  desc "Migrate the database"
  task(migrate: :environment) do
    Seabase.env = ENV['SEABASE_ENV'].to_sym rescue :development
    ActiveRecord::Base.establish_connection(
      ActiveRecord::Base.configurations[Seabase.env.to_s])
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate("db/migrate")
  end
end

task :environment do
  require_relative 'lib/seabase'
end

task(release: :environment) do
  require 'git'
  g = Git.open(File.dirname(__FILE__))
  new_tag = seabase.version
    g.add_tag("v.%s" % new_tag)
    g.add(all: true)
    g.commit("Releasing version %s" % new_tag)
    g.push
    `git push --tags`
  begin
  rescue Git::GitExecuteError
    puts "'v.#{new_tag}' already exists, update your version." 
  end
end

desc "Open an irb session preloaded with this library"
task :console do
    sh "irb -I lib -I extra -r seabase.rb"
end
