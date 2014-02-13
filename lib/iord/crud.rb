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
        crud_response_formats = crud_response_formats << Proc.new
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
      if @resource.save
        redirect_to resource_url, notice: 'Resource was successfully created.'
      else
        render action: 'new'
      end
    end

    def update
      if @resource.update_attributes! resource_params
        redirect_to resource_url, notice: 'Resource was successfully updated.'
      else
        render action: 'edit'
      end
    end

    def destroy
      @resource.destroy
      redirect_to collection_url, notice: 'Resource was successfully destroyed.'
    end

    private
    def formats(format)
      self.class.crud_response_formats.each do |callback|
        callback.call self, format, params[:action].to_sym
      end
    end
  end
end

