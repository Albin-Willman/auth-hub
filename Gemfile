source 'https://rubygems.org'

gem 'rails', '4.2.5'

gem 'rails-api'
gem 'puma'
gem 'rack-cors', require: 'rack/cors'
gem 'active_model_serializers', '~> 0.10.0.rc3'

gem 'apipie-rails', '~> 0.3' # Easy API documentation
gem 'maruku', '~> 0.7' # Needed for apipie-rails markdown support

gem 'bcrypt'
gem 'has_secure_token'

group :production do
  gem 'pg'
end

group :development do
  gem 'spring'
  gem 'mysql2'
  gem 'did_you_mean'
  gem 'bullet', '~> 4.14'
  gem 'binding_of_caller', '~> 0.7'
  gem 'better_errors', '~> 2.1'
  gem 'annotate', '~> 2.6'
  gem 'web-console', '~> 2.0'
end

group :test do
  gem 'rspec-rails', '~> 3.4'
  gem 'regressor', '~> 0.6'
  gem 'faker'
  gem 'codeclimate-test-reporter', require: false
  gem 'simplecov', '~> 0.11', require: false
  gem 'factory_girl_rails', '~> 4.0'
  gem 'database_cleaner', '~> 1.5'
end
