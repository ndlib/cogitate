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
gem 'airbrake', github: 'jeremyf/airbrake'
gem 'rest-client'

group :development do
  gem 'web-console'
  gem 'pry-byebug'
end

group :test do
  gem 'rspec-rails'
  gem 'commitment', require: false
  gem 'rspec-its'
  gem 'shoulda-matchers'
  gem 'rubocop'
end

group :deployment do
  gem 'capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  gem 'capistrano-passenger'
end

group :documentation do
  gem 'yard'
  gem 'yard-contracts'
  gem 'yard-activerecord'
end
