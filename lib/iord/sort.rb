require 'active_support/concern'

module Iord
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
        collection_url_defaults[:order_by] = @order_by
      end
      return @order_by
    end

    def sort_mode
      if @sort_mode.nil?
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

