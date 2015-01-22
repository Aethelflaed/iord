require 'active_support/concern'
require 'iord/json_output'

module Iord
  module Json
    extend ActiveSupport::Concern

    included do
      crud_response_format do |instance, format, action, hsh|
        method = "json_#{action}".to_sym
        if instance.respond_to? method
          format.json do
            instance.render(instance.public_send(method, hsh))
          end
        end
      end

      iord_features << :json
    end

    def iordh
      if request.format.symbol == :json
        @json_output ||= ::Iord::JsonOutput.new(view_context)
      else
        super
      end
    end

    def json_index_attrs
      self.respond_to?(:json_attrs) ?
        json_attrs :
        index_attrs
    end

    def json_show_attrs
      self.respond_to?(:json_attrs) ?
        json_attrs :
        show_attrs
    end

    def json_index(hsh)
      attrs = json_index_attrs
      attrs.unshift(:id) unless attrs.include? :id
      {json: iordh.display_array(@collection, attrs)}
    end

    def json_show(hsh)
      attrs = json_show_attrs
      attrs.unshift(:id) unless attrs.include? :id
      {json: iordh.display(@resource, attrs)}
    end

    def json_create(hsh)
      {status: hsh[:created] ? :created : :unprocessable_entity}.merge json_show(hsh)
    end

    def json_update(hsh)
      {status: hsh[:updated] ? :accepted : :unprocessable_entity}.merge json_show(hsh)
    end

    def json_destroy(hsh)
      {
        json: {status: hsh[:destroyed] ? "ok" : "error"},
        status: hsh[:destroyed] ? :ok : :unprocessable_entity
      }
    end
  end
end

