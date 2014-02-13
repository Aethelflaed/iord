require 'active_support/concern'
require 'iord/resource_info'
require 'iord/resource_url'
require 'iord/crud'
require 'iord/attributes'
require 'iord/fields'
require 'iord/resolver'

# Information Oriented Representation of Data
module Iord
  module Controller
    extend ActiveSupport::Concern
    include Iord::ResourceInfo
    include Iord::ResourceUrl
    include Iord::Attriutes
    include Iord::Crud
    include Iord::Fields

    included do
      append_view_path Iord::Resolver.new

      before_action :set_resource

      cattr_accessor :resource_based_actions, instance_accesssor: false do
        %i(show edit update destroy)
      end
    end

    module ClassMethods
      def resource_actions(*actions)
        actions = *actions if actions.size == 1 and actions[0].is_a? Array
        resource_based_actions = resource_based_actions + actions
      end
      alias :resource_action :resource_actions

      def resource_actions!(*actions)
        actions = *actions if actions.size == 1 and actions[0].is_a? Array
        resource_based_actions = actions
      end
    end

    protected
    def set_resource
      return unless self.class.resource_based_actions.include? params[:action].to_sym
      @resource = resource_class.find params[:id]
    end
  end
end

