require 'iord/controller'

class Iord::GenericController < ApplicationController
  include Iord::Controller

  alias :original_build_resource_info :build_resource_info
  def build_resource_info
    return original_build_resource_info if self.class.name != 'Iord::GenericController'
    path = request.fullpath[1..-1].split('/')

    namespace = String.new
    if self.class.resource_namespace_value.is_a? Module
      namespace = self.class.resource_namespace_value.to_s + '::'
    elsif self.class.resource_namespace_value
      namespace = path[0..-2].join('/').camelize + '::'
    end

    class_name = path.last.camelize
    @collection_name = class_name.humanize
    resource_class = class_name.singularize
    @resource_name = resource_class.humanize
    @resource_class = (namespace + resource_class).constantize

    @resource_path = path[0..-2].map { |i| i.to_sym }
  end
end

