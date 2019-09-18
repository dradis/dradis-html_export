# Configure Rails Envinronment
ENV["RAILS_ENV"] ||= 'test'
require_relative "../spec/dummy/config/environment"
# ActiveRecord::Migrator.migrations_paths = [File.expand_path("../spec/dummy/db/migrate", __dir__)]
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'
require 'byebug'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

# require 'database_cleaner'
# require 'factory_bot_rails'


RSpec.configure do |config|
  config.include Capybara::DSL

  # Capybara javascript drivers require transactional fixtures set to false,
  # and we just use DatabaseCleaner to cleanup after each test instead.
  # Without transactional fixtures set to false none of the records created to
  # setup a test will be available to the browser, which runs under a seperate
  # server instance.
  # config.use_transactional_fixtures = false
  #
  # config.before(:each) do
  #   if example.metadata[:js]
  #     DatabaseCleaner.strategy = :truncation
  #   else
  #     DatabaseCleaner.strategy = :transaction
  #   end
  # end
  #
  # config.before(:each) do
  #   DatabaseCleaner.start
  # end
  #
  # config.after(:each) do
  #   DatabaseCleaner.clean
  # end
end
