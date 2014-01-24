require 'bundler'
require 'active_record'
require 'rake'
require 'rspec'
require 'rspec/core/rake_task'
require 'sinatra/activerecord/rake'
require_relative 'environment'

task :default => :spec

RSpec::Core::RakeTask.new do |t|
  t.pattern = 'spec/**/*spec.rb'
end

include ActiveRecord::Tasks

namespace :db do
  desc 'Create all the databases from config.yml'
  namespace :create do
    task(:all) do
      DatabaseTasks.create_all
    end
  end

  desc 'Drop all the databases from config.yml'
  namespace :drop do
    task(:all) do
      DatabaseTasks.drop_all
    end
  end
end
  
task :environment do
  require_relative 'lib/seabase'
end

desc 'Create release on github'
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

desc 'Populate seed data for tests'
task :seed do
  require_relative 'db/seed'
end

desc 'Open an irb session preloaded with this library'
task :console do
    sh "irb -I lib -I extra -r seabase.rb"
end
