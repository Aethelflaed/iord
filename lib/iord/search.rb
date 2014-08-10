require 'active_support/concern'

module Iord
  class OutputHelper
    def search_if_enabled
      search_form if v.iord_features.include? :search
    end

    def search_form
      v.form_tag(v.collection_url, method: :get, class: 'search') do
        search_term +
          search_operand +
          search_value +
          search_submit
      end
    end

    def search_term
      html = %q[<select name="q" id="search_term">]
      if v.search_term.nil?
        html += %Q[<option value="">#{v.t('iord.search.select_field')}</option>]
      else
        html += %Q[<option value="">#{v.t('iord.search.reset')}</option>]
      end
      v.resource_class.attribute_names.each do |attr|
        html += %Q[<option value="#{attr}"]
        html += %q[ selected="selected"] if attr == v.search_term
        html += %Q[>#{attr.humanize}</option>] if attr != '_id'
        html += %q[>ID</option>] if attr == '_id'
      end
      html += %q[</select>]
      return html.html_safe
    end

    def search_operand
      html = %q[<select name="op" id="search_operand">]
      v.search_operands.each do |op|
        html += %Q[<option value="#{op}"]
        html += %q[ selected="selected"] if op == v.search_operand
        html += %Q[>#{v.t("iord.search.operand.#{op}")}</option>]
      end
      html += %q[</select>]
      return html.html_safe
    end

    def search_value
      v.text_field_tag('v', v.search_value, id: 'search_value')
    end

    def search_submit
      v.submit_tag(v.t('iord.search.submit'), name: "")
    end
  end

  module Search
    extend ActiveSupport::Concern

    included do
      alias_method_chain :create_collection, :search

      iord_features << :search

      helper_method :search_term
      helper_method :search_value
      helper_method :search_operand
      helper_method :search_operands
    end

    module ClassMethods
      def create_collection_returns_array?
        true
      end
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

    def search_operands
      @search_operands ||= %i(eq lt lte gt gte like)
    end

    def search_operand
      if @search_operand.nil?
        return @search_operand = nil if search_term.nil?
        @search_operand = (params[:op] || :eq).to_sym
        @search_operand = :eq unless search_operands.include? @search_operand

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

