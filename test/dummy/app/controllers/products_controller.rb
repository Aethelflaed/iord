require 'iord/controller'
require 'iord/json'
require 'iord/sort'

class ProductsController < ApplicationController
  include Iord::Controller
  include Iord::Json
  include Iord::Sort

  def index_attrs
    %i(name reference quantity)
  end

  def show_attrs
    %i(name reference quantity) + [
      {category: :name}
    ]
  end

  def form_attrs
    %i(name reference) + [
      [:number_field, :quantity],
      {
        attr: :category,
        fields: [
          :name
        ]
      }
    ]
  end
end

