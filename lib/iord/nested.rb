require 'active_support/concern'

module Iord
  module Nested
    extend ActiveSupport::Concern

    included do
      cattr_accessor :parent_models, instance_accesssor: false do
        []
      end

      #alias_method_chain :collection_url, :nested
      alias_method_chain :resource_url, :nested
      alias_method_chain :edit_resource_url, :nested

      alias_method_chain :set_resource, :nested
      alias_method_chain :build_resource_info, :nested
    end

    def index
      @collection = @parent.public_send("#{resource_name_u.pluralize}")
    end

    def create
      @resource = resource_class.new resource_params
      if @parent.respond_to? "#{resource_name_u}=".to_sym
        @parent.public_send "#{resource_name_u}=".to_sym, @resource
      elsif @parent.respond_to? "#{resource_name_u.pluralize}".to_sym
        collection = @parent.public_send "#{resource_name_u.pluralize}".to_sym
        collection << @resource
      end

      create!
    end

    def resource_url_with_nested(resource = nil)
      resource ||= @resource
      resource = nil unless has_collection?
      self.public_send resource_url_method, *(@parents + [resource])
    end

    def collection_url_with_nested
      self.public_send collection_url_method, *@parents
    end

    def edit_resource_url_with_nested(resource = nil)
      resource ||= @resource
      resource = nil unless has_collection?
      self.public_send "edit_#{resource_url_method}".to_sym, *(@parents + [resource])
    end

    def set_resource_with_nested
      @parents = Array.new
      @parent = nil
      if self.class.parent_models.empty?
        path = request.path[1..-1].split('/').reject { |x| x =~ /^new|edit|[a-f0-9]$/ }
        path = path[0..-2].map { |x| x.singularize.camelize.constantize }
        self.class.parent_models = path
      end
      self.class.parent_models.each do |model|
        param = "#{model.name.underscore}_id".to_sym
        parent = @parents.empty? ? model : @parent
        @parent = parent.find(params[param])
        @parents << @parent
      end
      return unless self.class.resource_based_actions.include? params[:action].to_sym
      if @parent.respond_to? "#{resource_name_u.pluralize}".to_sym
        @resource = @parent.public_send("#{resource_name_u.pluralize}").find(params[:id])
      else
        @resource = @parent.public_send(resource_name_u)
        if @resource.nil?
          @resource = resource_class.new
          @parent.public_send("#{resource_name_u}=".to_sym, @resource)
        end
      end
    end

    def build_resource_info_with_nested
      return if @parent_path
      build_resource_info_without_nested
      path = request.path[1..-1].split('/')
      path.reject! { |x| x =~ /^(new|edit|[a-f0-9]+)$/i } .map! { |x| x.singularize }
      @action_path = path.join('_').pluralize

      parent_path = self.class.parent_models.map { |x| x.name.underscore }
      @parent_path = parent_path.join('/')
    end

    module ClassMethods
      def parent_model(*models)
        models = *models if models.size == 1 and models[0].is_a? Array
        self.parent_models = models
      end
    end
  end
end

