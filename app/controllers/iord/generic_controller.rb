require 'iord/controller'

class Iord::GenericController < ApplicationController
  include Iord::Controller

  alias :original_build_resource_info :build_resource_info
  def build_resource_info
    return original_build_resource_info if self.class.name != 'Iord::GenericController'
    path = request.path[1..-1].split('/')
    # if new or edit
    path.pop if path.last =~/^(new|edit)$/
    # if ID
    path.pop if path.last =~ /^[a-f0-9]+$/

    namespace = String.new
    if self.class.resource_namespace.is_a? Module
      namespace = self.class.resource_namespace.to_s + '::'
    elsif self.class.resource_namespace
      namespace = path[0..-2].join('/').camelize + '::'
    end

    class_name = path.last.camelize
    @collection_name = class_name.humanize
    resource_class = class_name.singularize
    @resource_name = resource_class.humanize
    @resource_name_u = resource_class.underscore
    @resource_class = (namespace + resource_class).constantize

    prepend_view_path Iord::GenericResolver.new("app/views/#{path[0..-2].join('/')}", path.last)
    @action_path = path.join('_')

    @resource_path = path[0..-2].map { |i| i.to_sym }
  end
end

