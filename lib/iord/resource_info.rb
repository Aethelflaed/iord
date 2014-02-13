require 'active_support/concern'

module Iord
  module ResourceInfo
    extend ActiveSupport::Concern

    included do
      helper_method :resource_class
      helper_method :resource_name
      helper_method :collection_name
      helper_method :resource_path
    end

    def resource_class
      build_resource_info unless @resource_class
      @resource_class
    end

    def resource_name
      build_resource_info unless @resource_name
      @resource_name
    end

    def collection_name
      build_resource_info unless @collection_name
      @collection_name
    end

    def resource_path
      build_resource_info unless @resource_path
      @resource_path
    end

    def build_resource_info
      return if @resource_class
      controller_name = self.class.name[0..-11]

      namespace = String.new
      if self.class.resource_namespace_value.is_a? Module
        namespace = self.class.resource_namespace_value.to_s + '::'
      elsif self.class.resource_namespace_value
        namespace = controller_name[0..controller_name.rindex(':')] if controller_name.rindex(':')
      end

      class_name = self.class.controller_name.camelize
      @collection_name = class_name.humanize
      resource_class = class_name.singularize
      @resource_name = resource_class.humanize
      @resource_class = (namespace + resource_class).constantize

      path = controller_path[0..controller_path.rindex('/')-1]
      @resource_path = path.split('/').map { |i| i.to_sym }
    end

    module ClassMethods
      def resource_namespace_value
        @@resource_namespace ||= false
      end

      def resource_namespace(namespace = true)
        @@resource_namespace = namespace
      end
    end
  end
end

