require 'faker/name'

FactoryGirl.define do
  factory :category do
    name { Faker::Name.name }
  end
end

