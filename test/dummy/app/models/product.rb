class Product
  include Mongoid::Document

  field :name
  field :reference
  field :quantity, type: Integer

  belongs_to :category

  embeds_many :comments, as: :commentable
  embeds_one :manager, as: :managable

  validates_presence_of :name
  validates_associated :category

  accepts_nested_attributes_for :category
end

