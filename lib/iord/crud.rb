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

    def index
      @collection = resource_class.all
      respond_to do |format|
        format.html { render }
        formats(format)
      end
    end

    def show
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
      respond_to do |format|
        format.html { render }
        formats(format)
      end
    end

    def edit
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
      respond_to do |format|
        if @resource.save
          flash[:notice] = t('iord.flash.create.notice', model: resource_name)
          format.html { redirect_to resource_url }
          formats(format, created: true)
        else
          format.html { render action: 'new' }
          formats(format, created: false)
        end
      end
    end

    def update
      @resource.update_attributes resource_params
      respond_to do |format|
        if @resource.save
          flash[:notice] = t('iord.flash.update.notice', model: resource_name)
          format.html { redirect_to resource_url }
          formats(format, updated: true)
        else
          format.html { render action: 'edit' }
          formats(format, updated: false)
        end
      end
    end

    def destroy
      respond_to do |format|
        if @resource.destroy
          flash[:notice] = t('iord.flash.destroy.notice', model: resource_name)
          format.html { redirect_to collection_url }
          formats(format, destroyed: true)
        else
          flash[:alert] = t('iord.flash.destroy.alert', model: resource_name)
          format.html { redirect_to collection_url }
          formats(format, destroyed: false)
        end
      end
    end

    private
    def formats(format, hash = {})
      self.class.crud_response_formats.each do |callback|
        callback.call(self, format, params[:action].to_sym, hash)
      end
    end
  end
end

