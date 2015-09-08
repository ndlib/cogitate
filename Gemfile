source 'https://rubygems.org'

gem 'rails'
gem 'jbuilder'
gem 'figaro'
gem 'mysql2', '~> 0.3.13'
gem 'contracts'
gem 'omniauth'
gem 'omniauth-cas'
gem 'jwt'
gem 'data_migrator', github: 'jeremyf/data-migrator'

group :development, :test do
  gem 'web-console'
  gem 'pry-byebug'
  gem 'rspec-rails'
  gem 'commitment', require: false
  gem 'rspec-its'
  gem 'shoulda-matchers'
  gem 'rest-client'
  # Needed until rubocop 0.4.1 is released; See https://github.com/bbatsov/rubocop/commit/f367cb81b60f4a164c82650c055820797be9551f
  gem 'rubocop', github: 'bbatsov/rubocop'
end

group :development do
  gem 'capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
end

group :documentation do
  gem 'yard'
  gem 'yard-contracts'
  gem 'yard-activerecord'
end
