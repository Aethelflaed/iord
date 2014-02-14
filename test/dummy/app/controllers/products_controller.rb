require 'iord/controller'

class ProductsController < ApplicationController
  include Iord::Controller

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
        fields: %i(name) + [{
            attr: :_id,
            hidden: :true,
            field: [:hidden_field, :_id],
            not_new_record: true
        }]
      }
    ]
  end
end

