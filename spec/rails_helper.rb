require 'codeclimate-test-reporter'
require 'simplecov'
SimpleCov.start 'rails'

CodeClimate::TestReporter.start if ENV.fetch('CODECLIMATE_REPO_TOKEN', false)

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production

abort('Rails is running in production mode!') if Rails.env.production?

require 'spec_helper'
require 'rspec/rails'
require 'shoulda/matchers'

ActiveRecord::Migration.maintain_test_schema!
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.clean_with(:truncation)
  end
  config.include Requests::JsonHelpers, type: :request
end
