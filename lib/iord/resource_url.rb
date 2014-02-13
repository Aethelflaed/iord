require 'active_support/concern'

module Iord
  module ResourceUrl
    extend ActiveSupport::Concern

    included do
      helper_method :resource_url
      helper_method :collection_url
      helper_method :new_resource_url
      helper_method :edit_resource_url
    end

    def resource_url_method
      @resource_url_method ||= resource_class.name.underscore + '_url'
    end

    def collection_url_method
      @collection_url_method ||= (resource_class.name.pluralize.underscore + '_url').to_sym
    end

    def resource_url(resource = nil)
      self.public_send resource_url_method.to_sym, (resource || @resource)
    end

    def collection_url
      @collection_url ||= self.public_send collection_url_method
    end

    def new_resource_url
      @new_resource_url ||= self.public_send "new_#{resource_url_method}".to_sym
    end

    def edit_resource_url(resource = nil)
      @edit_resource_url ||= self.public_send "edit_#{resource_url_method}".to_sym, (resource || @resource)
    end
  end
end

