require 'bundler/setup'
require 'simplecov'
SimpleCov.configure do
  add_filter '/test/'
end
SimpleCov.start if ENV['COVERAGE']

require 'minitest/autorun'

ENV['RAILS_ENV'] = 'test'
require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require 'rails/test_help'
require 'factory_girl'
require 'nested_form/view_helper'

Mongoid::Sessions.default.use('iord_test').drop

# FactoryGirl can't find definitions :/
FactoryGirl.definition_file_paths = [File.expand_path('../factories', __FILE__)]
FactoryGirl.find_definitions

Rails.backtrace_cleaner.remove_silencers!

ActiveSupport::TestCase.test_order = :random

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
end

# fixes NestedForm not avilable in test
class ActionView::Base
  include NestedForm::ViewHelper
end

