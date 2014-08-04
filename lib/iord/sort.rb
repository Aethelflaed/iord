require 'active_support/concern'

module Iord
  class OutputHelper
    def order_by(attribute)
      content = String.new
      if v.resource_class.attribute_names.include? attribute.to_s
        content += v.link_to sort_desc_symbol, v.collection_url(order_by: attribute, sort_mode: :desc)
        content += "&nbsp;"
        content += v.link_to sort_asc_symbol, v.collection_url(order_by: attribute, sort_mode: :asc)
      end
      return content.html_safe
    end

    def sort_asc_symbol
      '\\/'
    end

    def sort_desc_symbol
      '/\\'
    end
  end

  module Sort
    extend ActiveSupport::Concern

    included do
      alias_method_chain :create_collection, :sort

      iord_features << :sort
    end

    def order_by
      if @order_by.nil?
        @order_by = params[:order_by]
        @order_by = nil unless resource_class.attribute_names.include? @order_by
        collection_url_defaults[:order_by] = @order_by if @order_by
      end
      return @order_by
    end

    def sort_mode
      if @sort_mode.nil?
        return @sort_mode = nil if order_by.nil?
        @sort_mode = (params[:sort_mode] || :asc).to_sym
        @sort_mode = :asc unless %i(asc desc).include? @sort_mode
        collection_url_defaults[:sort_mode] = @sort_mode
      end
      return @sort_mode
    end

    def create_collection_with_sort
      if order_by
        create_collection_without_sort.order_by(order_by => sort_mode)
      else
        create_collection_without_sort
      end
    end
  end
end

