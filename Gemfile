source 'https://rubygems.org'
ruby '2.2.3'

gem 'rails'
gem 'jbuilder'
gem 'figaro'
gem 'mysql2'
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
