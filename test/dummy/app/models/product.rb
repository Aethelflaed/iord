class Product
  include Mongoid::Document

  field :name
  field :reference
  field :quantity

  belongs_to :category
end

