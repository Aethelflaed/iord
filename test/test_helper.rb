# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"
require 'database_cleaner'
require 'faker'
require 'factory_girl'
require 'nested_form/view_helper'

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

FactoryGirl.find_definitions

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Load fixtures from the engine
if ActiveSupport::TestCase.method_defined?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
end

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
end

# fixes NestedForm not avilable in test
class ActionView::Base
  include NestedForm::ViewHelper
end

