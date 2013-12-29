require 'rubygems'
require 'bundler'
#Bundler.require :default, :development
#Bundler.require :development
#puts "--- #{Object.constants}"

require 'combustion'
require 'capybara/rspec'

Dir[File.join File.dirname(__FILE__), 'support', '**', '*.rb'].each {|file| require file}

Combustion.initialize! :action_controller, :action_view, :sprockets do |app|
  app.config.assets.cache_store = :null_store
#  app.config.sass.cache = false
end

Capybara.app = Combustion::Application

require 'rspec/rails'
#require 'capybara/rails'

# [deprecated] I18n.enforce_available_locales will default to true in the future.
# If you really want to skip validation of your locale you can set
# I18n.enforce_available_locales = false to avoid this message.
# TODO: remove following line and get rspec run without warnings
I18n.enforce_available_locales = false

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  #config.use_transactional_fixtures = true
  config.filter_run :focus
  config.order = 'random'

#  config.before do
#  end
end
