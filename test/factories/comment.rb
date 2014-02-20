require 'faker/name'
require 'faker/lorem'

FactoryGirl.define do
  factory :comment do
    author_name { Faker::Name.name }
    content { Faker::Lorem.paragraphs(1) }
    commentable { build(:product) }
  end
end

