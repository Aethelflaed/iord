require 'faker/name'

FactoryGirl.define do
  factory :manager do
    firstname { Faker::Name.first_name }
    lastname  { Faker::Name.last_name }
    managable { build(:product) }
  end
end

