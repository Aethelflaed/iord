require 'active_support/concern'

module Iord
  class OutputHelper
    def pagination
      limit = v.limit
      offset = v.offset
      page_div = %Q[<div class="page">]
      (v.count / limit + 1).times do |i|
        if (i * limit) == offset
          page_div += page(i)
        else
          page_div += v.link_to page(i), v.collection_url(offset: i * limit)
        end
      end
      page_div += %Q[</div>]
      return page_div.html_safe
    end

    def page(i)
      %Q[<span class="page">#{i}</span>].html_safe
    end
  end

  module Paginate
    extend ActiveSupport::Concern

    included do
      alias_method_chain :create_collection, :pagination
      alias_method_chain :index!, :pagination

      helper_method :limit
      helper_method :offset
      helper_method :count
    end

    def index_with_pagination!
      if request.format.symbol == :html
        render 'index_paginated'
      else
        index_without_pagination!
      end
    end

    def limit
      if @limit.nil?
        @limit = Integer(params[:limit] ||
                         default(:limit) ||
                         Rails.configuration.try(:iord_pagination_default_limit) ||
                         25)
        collection_url_defaults[:limit] = @limit
      end
      return @limit
    end

    def offset
      @offset ||= Integer(params[:offset] || 0)
    end

    def count
      @count ||= create_collection.count
    end

    def create_collection_with_pagination
      create_collection_without_pagination.limit(limit).skip(offset)
    end
  end
end

