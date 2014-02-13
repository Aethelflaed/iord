require 'active_support/concern'

module Iord
  module Json
    extend ActiveSupport::Concern

    included do
      crud_response_format do |instance, format, action|
        case action
        when :index
          format.json { instance.render json: instance.json_build_collection }
        when :show
          format.json { instance.render json: instance.json_build_resource }
        end
      end

      helper_method :json_index_attrs
      helper_method :json_show_attrs
    end

    def json_index_attrs
      %i(_id to_s) + index_attrs
    end

    def json_show_attrs
      show_attrs
    end

    def json_build_collection
      json = []
      opts = {collection: true}
      @collection.each do |resource|
        json << json_build_resource(resource, json_index_attrs, opts)
      end
      json
    end

    def json_build_resource(resource = nil, attrs = nil, opts = {})
      resource ||= @resource
      raise ArgumentError, "No resource given" if resource.nil?
      attrs ||= json_show_attrs
      opts[:json] = true

      json = {}
      attrs.each do |attr|
        json[field_name(attr)] = field_value(resource, attr, opts)
      end
      json
    end
  end
end

