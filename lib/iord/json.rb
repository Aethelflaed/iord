require 'active_support/concern'
require 'iord/json_output'

module Iord
  module Json
    extend ActiveSupport::Concern

    included do
      crud_response_format do |instance, format, action, hash|
        method = "json_#{action}".to_sym
        if instance.respond_to? method
          format.json do
            instance.render(instance.public_send(method, hash))
          end
        end
      end

      before_set_resource do
        if request.format.symbol == :json
          self.o = ::Iord::JsonOutput.new(view_context)
        end
      end

      iord_features << :json
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

    def json_index(hash)
      attrs = json_index_attrs
      attrs.unshift(:id) unless attrs.include? :id
      {json: o.display_array(@collection, attrs)}
    end

    def json_show(hash)
      attrs = json_show_attrs
      attrs.unshift(:id) unless attrs.include? :id
      {json: o.display(@resource, attrs)}
    end

    def json_create(hash)
      {status: hash[:created] ? :created : :unprocessable_entity}.merge json_show(hash)
    end

    def json_update(hash)
      {status: hash[:updated] ? :accepted : :unprocessable_entity}.merge json_show(hash)
    end

    def json_destroy(hash)
      {
        json: {status: hash[:destroyed] ? "ok" : "error"},
        status: hash[:destroyed] ? :ok : :unprocessable_entity
      }
    end
  end
end

