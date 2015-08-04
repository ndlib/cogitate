source 'https://rubygems.org'
ruby '2.2.2'

gem 'rails'
gem 'jbuilder', '~> 2.0'
gem 'figaro', '~> 1.1'
gem 'mysql2'
gem 'contracts'
gem 'omniauth'
gem 'omniauth-cas'
gem 'jwt'

group :development, :test do
  gem 'web-console', '~> 2.0'
  gem 'pry-byebug'
  gem 'rspec-rails'
  gem 'commitment', require: false
  gem 'rspec-its'
  gem 'shoulda-matchers'
end

group :development do
  gem 'capistrano', '~> 3.0.1'
  gem 'capistrano-bundler'
  gem 'capistrano-rails', '~> 1.1.0'
  gem 'capistrano-rvm', '~> 0.1.1'
end

group :documentation do
  gem 'yard'
  gem 'yard-contracts'
  gem 'yard-activerecord'
end
