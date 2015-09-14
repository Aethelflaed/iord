require 'active_support/concern'

module Iord
  class OutputHelper
    def paginate_if_enabled
      pagination if v.iord_features.include? :paginate
    end

    def pagination
      limit = v.limit
      offset = v.offset
      count = v.count
      page_div = %q[<p class="page">]
      page_div += %Q[#{v.t('iord.text.page')} ]

      if offset - limit + 1 > 0
        page_div += v.link_to "<", v.collection_url(offset: offset - limit)
        page_div += "&nbsp;"
      end

      (count / limit + 1).ceil.times do |i|
        page_div += "&nbsp;" unless i == 0
        if (i * limit) == offset
          page_div += page(i)
        else
          page_div += v.link_to page(i), v.collection_url(offset: i * limit)
        end
      end

      if offset < (count - limit)
        page_div += "&nbsp;"
        page_div += v.link_to ">", v.collection_url(offset: offset + limit)
      end

      page_div += %Q[</p>]
      return page_div.html_safe
    end

    def page(i)
      %Q[<span class="page">#{i + 1}</span>].html_safe
    end
  end

  module Paginate
    extend ActiveSupport::Concern

    included do
      alias_method_chain :create_collection, :pagination

      helper_method :limit
      helper_method :offset
      helper_method :count

      iord_features << :paginate
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

