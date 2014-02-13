require 'faker/name'
require 'faker/number'

FactoryGirl.define do
  factory :product do
    name { Faker::Name.name }
    reference { Faker::Name.name }
    quantity { Faker::Number.digit }
  end
end

