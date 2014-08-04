require 'iord/controller'
require 'iord/hooks'

class CategoriesController < ApplicationController
  include Iord::Controller

  def index_attrs
    %i(name)
  end

  def show_attrs
    %i(name) + [
      {
        array: :products,
        attr: {
          attrs: %i(name reference quantity)
        }
      }
    ]
  end

  def form_attrs
    %i(name) + [
      {
        attr: :products,
        fields: [
          {
            attr: :_id,
            hidden: :true,
            field: [:hidden_field, :_id],
            not_new_record: true
          }
        ] + %i(name reference quantity)
      }
    ]
  end
end

