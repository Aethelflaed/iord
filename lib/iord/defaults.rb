require 'active_support/concern'

module Iord
  module Defaults
    extend ActiveSupport::Concern

    included do
      cattr_accessor :_iord_defaults, instance_accesssor: false do
        {}
      end
      self.singleton_class.send(:alias_method, :defaults, :_iord_defaults=)
    end

    def default(key)
      self.class._iord_defaults[key]
    end
  end
end

