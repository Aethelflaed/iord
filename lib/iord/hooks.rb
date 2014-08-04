require 'active_support/concern'

module Iord
  module Hooks
    extend ActiveSupport::Concern

    included do
    end

    def create_with_hooks!
      if create_without_hooks!
        execute_hook(resource_name_u, :create)
      end
    end
    alias_method_chain :create!, :hooks

    def update_with_hooks!
      if update_without_hooks!
        execute_hook(resource_name_u, :update)
      end
    end
    alias_method_chain :update!, :hooks

    def destroy_with_hooks!
      if destroy_without_hooks!
        execute_hook(resource_name_u, :destroy)
      end
    end
    alias_method_chain :destroy!, :hooks

    def execute_hook(resource_name, action)
      Iord::HookSet.execute_hook(resource_name, action, @resource)
    end

    def register_hook(resource_name, action)
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

    module ClassMethods
    end
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
          hook.call(action, resource)
        end
      end
    end
  end
end

