require 'active_support/concern'

module Iord
  module Crud
    extend ActiveSupport::Concern

    included do
      cattr_accessor :crud_response_formats, instance_accesssor: false do
        []
      end
    end

    module ClassMethods
      def crud_response_format
        raise ArgumentError, "block expected" unless block_given?
        self.crud_response_formats = self.crud_response_formats << Proc.new
      end
    end

    def create_collection
      resource_class.all
    end

    def index_collection
      @collection = create_collection
    end
    def index
      index_collection
      respond_to do |format|
        format.html { render }
        formats(format)
      end
    end

    def show_resource
    end
    def show
      show_resource
      respond_to do |format|
        format.html { render }
        formats(format)
      end
    end

    def new_resource
      @resource = resource_class.new
      resource_class.relations.each do |name, rel|
        if rel.autosave and @resource.respond_to? "build_#{name}".to_sym
          @resource.public_send "build_#{name}".to_sym
        end
      end
    end
    def new
      new_resource
      respond_to do |format|
        format.html { render }
        formats(format)
      end
    end

    def edit_resource
    end
    def edit
      edit_resource
      respond_to do |format|
        format.html { render }
        formats(format)
      end
    end

    def create_resource
      @resource = resource_class.new resource_params
    end
    def create
      create_resource
      result = @resource.save
      respond_to do |format|
        if result
          flash[:notice] = t('iord.flash.create.notice', model: resource_name)
          format.html { redirect_to resource_url }
        else
          format.html { render action: 'new' }
        end
        formats(format, created: result)
      end
      return result
    end

    def update_resource
      @resource.update_attributes(resource_params)
    end
    def update
      update_resource
      result = @resource.save
      respond_to do |format|
        if result
          flash[:notice] = t('iord.flash.update.notice', model: resource_name)
          format.html { redirect_to resource_url }
        else
          format.html { render action: 'edit' }
        end
        formats(format, updated: result)
      end
      return result
    end

    def destroy_resource
      @resource.destroy!
    end
    def destroy
      result = destroy_resource
      respond_to do |format|
        if result
          flash[:notice] = t('iord.flash.destroy.notice', model: resource_name)
          format.html { redirect_to collection_url }
        else
          flash[:alert] = t('iord.flash.destroy.alert', model: resource_name)
          format.html { redirect_to collection_url }
        end
        formats(format, destroyed: result)
      end
      return result
    end

    private
    def formats(format, hash = {})
      self.class.crud_response_formats.each do |callback|
        callback.call(self, format, params[:action].to_sym, hash)
      end
    end
  end
end

