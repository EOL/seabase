require 'bundler'
require 'active_record'
require 'rake'
require 'rspec'
require 'rspec/core/rake_task'
require 'sinatra/activerecord/rake'
require_relative 'lib/seabase'

task :default => :spec

RSpec::Core::RakeTask.new do |t|
  t.pattern = 'spec/**/*spec.rb'
end

include ActiveRecord::Tasks
ActiveRecord::Base.configurations = YAML.load(File.read('config/config.yml'))

namespace :db do
  desc 'create all the databases from config.yml'
  namespace :create do
    task(:all) do
      DatabaseTasks.create_all
    end
  end

  desc 'drop all the databases from config.yml'
  namespace :drop do
    task(:all) do
      DatabaseTasks.drop_all
    end
  end

  desc 'redo last migration'
  task :redo => ['db:rollback', 'db:migrate']
end

desc 'create release on github'
task(:release) do
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

desc 'populate seed data for tests'
task :seed do
  require_relative 'db/seed'
end

desc 'open an irb session preloaded with this library'
task :console do
    sh "irb -I lib -I extra -r seabase.rb"
end
