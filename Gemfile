source 'https://rubygems.org'
ruby '2.2.2'

gem 'rails-api'
gem 'jbuilder', '~> 2.0'
gem 'figaro', '>= 1.0.0.rc1'
gem 'mysql2'
gem 'contracts'

group :development, :test do
  gem 'web-console', '~> 2.0'
  gem 'spring'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'pry-rescue'
  gem 'rspec-rails'
  gem 'commitment', require: false
  gem 'rspec-its'
  gem 'shoulda-matchers'
end

group :development do
  gem 'better_errors'
  gem 'capistrano', '~> 3.0.1'
  gem 'capistrano-bundler'
  gem 'capistrano-rails', '~> 1.1.0'
  gem 'capistrano-rails-console'
  gem 'capistrano-rvm', '~> 0.1.1'
  gem 'quiet_assets'
end

group :documentation do
  gem 'yard'
  gem 'yard-contracts'
  gem 'yard-activerecord'
end

group :brakeman do
  # A shim to help brakeman; Without this Brakeman detects that we
  # are running Rails 3.x and that there are numerous vulnerabilites
  gem 'rails', '~> 4.2', require: false
end
