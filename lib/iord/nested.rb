require 'active_support/concern'

module Iord
  module Nested
    extend ActiveSupport::Concern

    included do
      #alias_method_chain :collection_url, :nested
      alias_method_chain :resource_url, :nested
      alias_method_chain :edit_resource_url, :nested

      alias_method_chain :set_resource, :nested
      alias_method_chain :build_resource_info, :nested
    end

    def parent_models
      @parent_models ||= default(:parent_models) || []
    end

    def parents_collection_names
      @parents_collection_names ||= default(:parents_collection_names) || []
    end

    def parent_collection_name
      @parent_collection_name ||=
        default(:parent_collection_name) || resource_name_u.pluralize.to_sym
    end

    def parent_resource_name
      @parent_resource_name ||=
        default(:parent_resource_name) || resource_name_u.to_sym
    end

    def index
      @collection = @parent.public_send(parent_collection_name)
      index!
    end

    def create
      @resource = resource_class.new resource_params
      if @parent.respond_to? "#{parent_resource_name}=".to_sym
        @parent.public_send "#{parent_resource_name}=".to_sym, @resource
      elsif @parent.respond_to? parent_collection_name
        collection = @parent.public_send parent_collection_name
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
      self.run_hook :before_set_resource
      @parents = Array.new
      @parent = nil
      if self.parent_models.empty?
        path = request.path[1..-1].split('/').reject { |x| x =~ /^#{params[:action]}|[a-f0-9]+(\.#{params[:format]})?$/ }
        path = path[0..-2].map { |x| x.singularize.camelize.constantize }
        @parent_models = path
      end
      self.parent_models.each_with_index do |model, index|
        param = "#{model.name.underscore}_id".to_sym
        collection = model
        unless @parents.empty?
          collection = @parent
          collection_name = self.parents_collection_names[index]
          if collection_name.nil?
            collection_name = model.name.underscore.pluralize.to_sym
          end
          collection = @parent.public_send(collection_name)
        end
        @parent = collection.find(params[param])
        @parents << @parent
      end
      return unless self.class.resource_based_actions.include? params[:action].to_sym
      if @parent.respond_to? parent_collection_name
        @resource = @parent.public_send(parent_collection_name).find(params[:id])
      else
        @resource = @parent.public_send(parent_resource_name)
        if @resource.nil?
          @resource = resource_class.new
          @parent.public_send("#{parent_resource_name}=".to_sym, @resource)
        end
      end
    end

    def build_resource_info_with_nested
      return if @parent_path
      build_resource_info_without_nested
      path = request.path[1..-1].split('/')
      path.reject! { |x| x =~ /^(new|edit|[a-f0-9]+)$/i } .map! { |x| x.singularize }
      @action_path = path.join('_').pluralize

      parent_path = self.parent_models.map { |x| x.name.underscore }
      @parent_path = parent_path.join('/')
    end
  end
end

