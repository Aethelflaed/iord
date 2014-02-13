require 'active_support/concern'

module Iord
  module Attriutes
    extend ActiveSupport::Concern

    included do
      helper_method :show_attrs
      helper_method :attrs
      helper_method :index_attrs
      helper_method :form_attrs
      helper_method :new_attrs
      helper_method :edit_attrs
    end

    def show_attrs
      @show_attrs ||= resource_class.attribute_names.map{ |i| i.to_sym } - %i(deleted_at)
    end

    def attrs
      @attrs ||= show_attrs - %i(_id created_at updated_at)
    end

    def index_attrs
      attrs
    end

    def form_attrs
      attrs
    end

    def new_attrs
      form_attrs
    end
    
    def edit_attrs
      form_attrs
    end

    protected
    def resource_params
      _attrs = @resource.nil? ? new_attrs : edit_attrs
      params.require(resource_class.name.underscore.to_sym).permit *construct_permit_params_array(_attrs)
    end

    def construct_permit_params_array(array)
      _attrs = []
      array.each do |a|
        if a.is_a? Hash
          if a.has_key? :fields
            _attrs << {(a[:attr].to_s + '_attributes').to_sym => construct_permit_params_array(a[:fields])}
          end
          _attrs << a[:attr]
        else
          _attrs << a
        end
      end
      # permit the destroy attribute
      _attrs << '_destroy'
    end
  end
end

