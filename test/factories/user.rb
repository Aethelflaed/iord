require 'faker/name'

FactoryGirl.define do
  factory :user, class: Admin::User do
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
  end
end

