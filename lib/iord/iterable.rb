require 'active_support/concern'

module Iord
  class OutputHelper
    def link_to_iterate_if_enabled
      link_to_iterate if v.iord_features.include?(:iterable)
    end

    def link_to_iterate
      v.link_to(v.t('iord.buttons.iterate'), v.iterate_url(true),
                class: 'btn btn-default')
    end

    def link_to_iterate_next_if_possible
      link_to_iterate_next if v.pos < v.collection_count - 1
    end

    def link_to_iterate_previous_if_possible
      link_to_iterate_previous if v.pos > 0
    end

    def link_to_iterate_next
      v.link_to(v.t('iord.buttons.next'), v.iterate_url(pos: v.pos + 1),
                class: 'btn btn-default')
    end

    def link_to_iterate_previous
      v.link_to(v.t('iord.buttons.previous'), v.iterate_url(pos: v.pos - 1),
                class: 'btn btn-default')
    end

    def iterate_form
      v.form_tag(v.iterate_url, method: :get, class: 'iterate') do
        html = ''
        if v.iord_features.include?(:search)
          html +=
            search_term +
            search_operator +
            search_value +
            '<br/>'
        end

        html += %Q[<label for="order_by">#{v.t('iord.text.order_by')}</label>]
        html += %q[<select name="order_by" id="order_by">]
        v.resource_attribute_names.each do |attr|
          html += %Q[<option value="#{attr}"]
          html += %q[ selected="selected"] if attr == v.order_by
          html += %Q[>#{attr.humanize}</option>] if attr != '_id'
          html += %q[>ID</option>] if attr == '_id'
        end
        html += %q[</select>]
        html += '<br/>'

        html += %Q[<label for="sort_mode">#{v.t('iord.text.sort_mode')}</label>]
        html += %q[<select name="sort_mode" id="sort_mode">]
        %i(asc desc).each do |sort_mode|
          html += %Q[<option value="#{sort_mode}"]
          html += %q[ selected="selected"] if sort_mode == v.sort_mode
          html += %Q[>#{v.t("iord.order_by.#{sort_mode}")}</option>]
        end
        html += %q[</select>]
        html += '<br/>'

        html += %Q[<label for="edit">#{v.t('iord.text.edit')}</label>]
        html += %q[<input type="checkbox" name="edit" id="edit" />]
        html += '<br/>'

        html += v.submit_tag(v.t('iord.buttons.iterate'), name: '')

        return html.html_safe
      end
    end
  end

  module Iterable
    extend ActiveSupport::Concern

    include Sort

    included do
      resource_actions :iterate

      iord_features << :iterable

      helper_method :pos
      helper_method :iterate_url
      helper_method :collection_count
      helper_method :iterate_edition
    end

    def iterate_edition
      if @iterate_edition.nil?
        @iterate_edition = params[:edit] ? true : false
        collection_url_defaults[:edit] = @iterate_edition
      end
      return @iterate_edition
    end

    def pos
      if @pos.nil?
        @pos = params[:pos]
        if @pos
          @pos = @pos.to_i
          collection_url_defaults[:pos] = @pos
        end
      end
      return @pos
    end

    def iterate_url(options = {})
      if options.present?
        if options == true
          options = collection_url_defaults
        else
          options = collection_url_defaults.merge(options)
        end
        return self.public_send "iterate_#{collection_url_method}".to_sym, options
      else
        @iterate_url = self.public_send "iterate_#{collection_url_method}".to_sym
      end
    end

    def collection_count
      @collection_count ||= create_collection.count
    end

    def iterate
      collection = create_collection
      @pos = pos || collection_count
      if @pos == -1
        @resource = collection.last
        @pos = collection_count - 1
      elsif @pos < collection_count
        @resource = collection.skip(pos).first
      else
        @resource = nil
        @pos = nil
      end
      collection_url_defaults[:pos] = @pos
    end
  end
end

