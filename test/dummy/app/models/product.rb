class Product
  include Mongoid::Document

  field :name
  field :reference
  field :quantity

  belongs_to :category

  validates_presence_of :name
  validates_associated :category

  accepts_nested_attributes_for :category
end

