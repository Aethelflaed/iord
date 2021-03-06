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
      helper_method :resource_attribute_names

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

    def resource_attribute_names
      build_resource_info unless @resource_attribute_names
      @resource_attribute_names
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

      @action_path = request.path[1..-1].split('/').
        reject { |x| x=~ /^(#{params[:action]}|[a-f0-9]+(\.#{params[:format]})?)$/ }.
        map { |x| x.singularize }.
        join('_').pluralize

      @resource_path = Array.new
      if controller_path.rindex('/')
        path = controller_path[0..controller_path.rindex('/')-1]
        @resource_path = path.split('/').map { |i| i.to_sym }
      end

      #@resource_attribute_names = @resource_class.attribute_names.map { |x| x == "_id" ? "id" : x }
      @resource_attribute_names = build_resource_attribute_names(@resource_class)
    end

    def build_resource_attribute_names(klass)
      attribute_names = klass.attribute_names.map{|x| x == '_id' ? 'id' : x}
      klass.relations.each do |name, relation|
        case relation.macro
        when :embeds_one, :embeds_many
          unless relation.cyclic? || klass.name == relation.class_name
            embedded_attributes = build_resource_attribute_names(relation.class_name.constantize)
            attribute_names += embedded_attributes.map{|attribute| "#{name}.#{attribute}"}
          end
        end
      end
      attribute_names
    end
  end
end

