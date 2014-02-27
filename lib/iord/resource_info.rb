require 'active_support/concern'

module Iord
  module ResourceInfo
    extend ActiveSupport::Concern

    included do
      helper_method :resource_class
      helper_method :resource_name
      helper_method :resource_name_u
      helper_method :collection_name
      helper_method :resource_path
      helper_method :action_path

      cattr_accessor :resource_namespace, instance_accesssor: false do
        false
      end
      self.singleton_class.send(:alias_method, :set_resource_namespace, :resource_namespace=)
    end

    def resource_class
      build_resource_info unless @resource_class
      @resource_class
    end

    def resource_name
      build_resource_info unless @resource_name
      @resource_name
    end

    def resource_name_u
      build_resource_info unless @resource_name_u
      @resource_name_u
    end

    def collection_name
      build_resource_info unless @collection_name
      @collection_name
    end

    def resource_path
      build_resource_info unless @resource_path
      @resource_path
    end

    def action_path
      build_resource_info unless @action_path
      @action_path
    end

    def build_resource_info
      return if @resource_class
      controller_name = self.class.name[0..-11]

      namespace = String.new
      if self.class.resource_namespace.is_a? Module
        namespace = self.class.resource_namespace.to_s + '::'
      elsif self.class.resource_namespace
        namespace = controller_name[0..controller_name.rindex(':')] if controller_name.rindex(':')
      end

      class_name = default(:resource_class)
      class_name ||= self.class.controller_name.camelize
      class_name = class_name.to_s
      @collection_name = class_name.humanize
      resource_class = class_name.singularize
      @resource_name = resource_class.humanize
      @resource_name_u = resource_class.underscore
      @resource_class = (namespace + resource_class).constantize

      path = request.path[1..-1].split('/')
      # if new or edit
      path.pop if path.last == params[:action]
      # if ID
      path.pop if path.last =~ /^[a-f0-9]+(\.#{params[:format]})?$/
      @action_path = path.join('_')

      @resource_path = Array.new
      if controller_path.rindex('/')
        path = controller_path[0..controller_path.rindex('/')-1]
        @resource_path = path.split('/').map { |i| i.to_sym }
      end
    end
  end
end

