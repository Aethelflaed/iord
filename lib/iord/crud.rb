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

      def create_collection_returns_array?
        false
      end
    end

    def create_collection
      resource_class.all
    end

    def index
      @collection = create_collection
      index!
    end
    def index!
      respond_to do |format|
        format.html { render }
        formats(format)
      end
    end

    def show
      show!
    end
    def show!
      respond_to do |format|
        format.html { render }
        formats(format)
      end
    end

    def new
      @resource = resource_class.new
      resource_class.relations.each do |name, rel|
        if rel.autosave and @resource.respond_to? "build_#{name}".to_sym
          @resource.public_send "build_#{name}".to_sym
        end
      end
      new!
    end
    def new!
      respond_to do |format|
        format.html { render }
        formats(format)
      end
    end

    def edit
      edit!
    end
    def edit!
      respond_to do |format|
        format.html { render }
        formats(format)
      end
    end

    def create
      @resource = resource_class.new resource_params
      create!
    end
    def create!
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

    def update
      @resource.update_attributes resource_params
      update!
    end
    def update!
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

    def destroy
      destroy!
    end
    def destroy!
      result = @resource.destroy
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

