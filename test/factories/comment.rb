require 'faker/name'
require 'faker/lorem'

FactoryGirl.define do
  factory :comment do
    author_name { Faker::Name.name }
    content { Faker::Lorem.paragraphs(1) }
    commentable { build(:product) }
  end

  factory :subcomment, class: 'Comment' do
    author_name { Faker::Name.name }
    content { Faker::Lorem.paragraphs(1) }
    commentable { build(:comment) }
  end
end

