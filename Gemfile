source "https://rubygems.org"

gem "rake", "~> 10.1"
gem "activerecord", "~> 4.0"
gem "mysql2", "~> 0.3"
gem "rack", "~> 1.5"
gem "rack-timeout", "~> 0.0.4"
gem "compass", "~> 1.0"
#locking version @realpath_rec problem in 3.4.2
gem "sass", "3.4.1"
gem "zen-grids", "~> 1.4"
gem "sinatra", "~> 1.4"
gem "sinatra-activerecord", "~> 2.0"
gem "sinatra-flash", "~> 0.3"
gem "sinatra-redirect-with-flash", "~> 0.2"
gem "haml", "~> 4.0"
gem "childprocess", "~> 0.5"

group :development do
  gem "byebug", "~> 3.3"
  gem "sinatra-reloader", "~> 1.0"
end

group :production do
  gem "unicorn", "~> 4.8"
end

group :test do
  gem "rspec", "~> 3.0"
  gem "webmock", "~> 1.17"
  gem "capybara-webkit", "~> 1.1"
  gem "capybara", "~> 2.2"
  gem "coveralls", "~> 0.7", require: false
  gem "travis-lint", "~> 2.0"
  gem "launchy", "~> 2.4"
  gem "git", "~> 1.2"
  gem "rack-test", "~> 0.6"
  gem "rubocop", "~> 0.25"
end
