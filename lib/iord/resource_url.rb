require 'active_support/concern'

module Iord
  module ResourceUrl
    extend ActiveSupport::Concern

    included do
      helper_method :has_collection?

      helper_method :form_resource_url
      helper_method :resource_url
      helper_method :collection_url
      helper_method :new_resource_url
      helper_method :edit_resource_url
    end

    def has_collection?
      @has_collection ||= self.respond_to? collection_url_method
    end

    def resource_url_method
      @resource_url_method ||= action_path.singularize + '_url'
    end

    def collection_url_method
      @collection_url_method ||= (action_path.pluralize + '_url').to_sym
    end

    def form_resource_url
      if @resource.persisted? or not has_collection?
        resource_url
      else
        collection_url
      end
    end

    def resource_url(resource = nil)
      resource ||= @resource
      resource = nil unless has_collection?
      self.public_send resource_url_method.to_sym, resource
    end

    def collection_url_defaults
      @collection_url_defaults ||= Hash.new
    end

    def collection_url(options = {})
      if options.present?
        if options == true
          options = collection_url_defaults
        else
          options = collection_url_defaults.merge options
        end
        return self.public_send collection_url_method, options
      else
        @collection_url ||= self.public_send collection_url_method
      end
    end

    def new_resource_url
      @new_resource_url ||= self.public_send "new_#{resource_url_method}".to_sym
    end

    def edit_resource_url(resource = nil)
      resource ||= @resource
      resource = nil unless has_collection?
      self.public_send "edit_#{resource_url_method}".to_sym, resource
    end
  end
end

