require 'faker/name'

FactoryGirl.define do
  factory :administrator do
    firstname { Faker::Name.first_name }
    lastname  { Faker::Name.last_name }
  end
end

