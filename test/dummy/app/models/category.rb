class Category
  include Mongoid::Document

  field :name

  has_many :products

  accepts_nested_attributes_for :products
end

