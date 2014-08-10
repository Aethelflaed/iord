require 'active_support/concern'

module Iord
  module Search
    extend ActiveSupport::Concern

    included do
      alias_method_chain :create_collection, :search

      iord_features << :search
    end

    def search_term
      if @search_term.nil?
        @search_term = params[:q]
        @search_term = nil unless resource_class.attribute_names.include? @search_term
        collection_url_defaults[:q] = @search_term if @search_term
      end
      return @search_term
    end

    def search_value
      if @search_value.nil?
        return @search_value = nil if search_term.nil?
        @search_value = params[:v]

        collection_url_defaults[:v] = @search_value if @search_value
      end
      return @search_value
    end

    def search_operand
      if @search_operand.nil?
        return @search_operand = nil if search_term.nil?
        @search_operand = (params[:op] || :eq).to_sym
        @search_operand = :eq unless %i(eq lt lte gt gte like).include? @search_operand

        collection_url_defaults[:op] = @search_operand if @search_operand
      end
      return @search_operand
    end

    def create_collection_with_search
      collection = create_collection_without_search
      if search_term
        if search_operand == :like
          collection = collection.where(search_term => /.*#{search_value}.*/i)
        else
          collection = collection.where(search_term => {"$#{search_operand}" => search_value})
        end
      end
      return collection
    end
  end
end

