require 'active_support/concern'
require 'hooks'
require 'iord/defaults'
require 'iord/resource_info'
require 'iord/resource_url'
require 'iord/crud'
require 'iord/attributes'
require 'iord/fields'
require 'iord/resolver'

# Not included, but made available
require 'iord/paginate'
require 'iord/sort'
require 'iord/search'
require 'iord/iterable'

# Information Oriented Representation of Data
module Iord
  module Controller
    extend ActiveSupport::Concern
    include Iord::Defaults
    include Iord::ResourceInfo
    include Iord::ResourceUrl
    include Iord::Attriutes
    include Iord::Crud
    include Iord::Fields

    included do
      include ::Hooks

      append_view_path Iord::Resolver.new
      define_hook :before_set_resource
      before_action :set_resource

      cattr_accessor :resource_based_actions, instance_accesssor: false do
        %i(show edit update destroy)
      end

      cattr_accessor :iord_features do
        Array.new
      end
      helper_method :iord_features
    end

    module ClassMethods
      def resource_actions(*actions)
        actions = *actions if actions.size == 1 and actions[0].is_a? Array
        self.resource_based_actions = self.resource_based_actions + actions
      end
      alias_method :resource_action, :resource_actions

      def resource_actions!(*actions)
        actions = *actions if actions.size == 1 and actions[0].is_a? Array
        self.resource_based_actions = actions
      end
    end

    protected
    def set_resource
      self.run_hook :before_set_resource
      return unless self.class.resource_based_actions.include? params[:action].to_sym
      if params[:id]
        @resource = resource_class.find params[:id]
      elsif resource_class.count > 0
        @resource = resource_class.first
      else
        @resource = resource_class.new
      end
    end
  end
end

