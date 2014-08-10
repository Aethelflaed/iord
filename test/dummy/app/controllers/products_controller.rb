require 'iord/controller'
require 'iord/json'

class ProductsController < ApplicationController
  include Iord::Controller
  include Iord::Json
  include Iord::Sort
  include Iord::Paginate
  include Iord::Search

  def index_attrs
    show_attrs
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

