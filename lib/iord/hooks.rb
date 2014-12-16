require 'active_support/concern'

module Iord
  module Hooks
    extend ActiveSupport::Concern

    included do
      alias_method_chain :create_resource, :hooks
      alias_method_chain :update_resource, :hooks
      alias_method_chain :destroy_resource, :hooks
    end

    def create_resource_with_hooks
      result = create_resource_without_hooks
      execute_hook(resource_name_u, :create)
      result
    end

    def update_resource_with_hooks
      result = update_resource_without_hooks
      execute_hook(resource_name_u, :update)
      result
    end

    def destroy_resource_with_hooks
      result = destroy_resource_without_hooks
      execute_hook(resource_name_u, :destroy)
      result
    end

    def execute_hook(resource_name, action)
      Iord::HookSet.execute_hook(resource_name, action, @resource)
    end

    def register_hook(resource_name, action = :all)
      hook = Proc.new
      if action.to_sym == :all
        Iord::HookSet.register_hook(resource_name, :create, hook)
        Iord::HookSet.register_hook(resource_name, :update, hook)
        Iord::HookSet.register_hook(resource_name, :destroy, hook)
      else
        Iord::HookSet.register_hook(resource_name, action, hook)
      end
    end
    module_function :register_hook
  end

  class HookSet
    cattr_accessor :hooks, instance_accesssor: false do
      Hash.new
    end

    def self.register_hook(name, action, hook)
      name = name.to_sym
      action = action.to_sym
      hooks[name] ||= Hash.new
      hooks[name][action] ||= Array.new
      hooks[name][action] << hook
    end

    def self.execute_hook(name, action, resource)
      name = name.to_sym
      action = action.to_sym
      if hooks[name] and hooks[name][action]
        hooks[name][action].each do |hook|
          hook.call(resource, action)
        end
      end
    end
  end
end

