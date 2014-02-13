require 'faker/name'

FactoryGirl.define do
  factory :client do
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
  end
end

