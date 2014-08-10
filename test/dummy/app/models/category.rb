class Category
  include Mongoid::Document

  field :name

  has_many :products

  validates_presence_of :name
  validates_associated :products

  accepts_nested_attributes_for :products, allow_destroy: true

  def to_s
    name
  end
end

