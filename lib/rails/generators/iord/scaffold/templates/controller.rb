<% if namespaced? -%>
require_dependency "<%= namespaced_file_path %>/application_controller"
<% end -%>
require 'iord/controller'

<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
  include Iord::Controller
<% unless class_path.empty? -%>

  <%= "set_resource_namespace #{class_path.map{ |m| m.camelize }.join('::')}" %>
<% end -%>

  def index_attrs
    [
<% attributes.reject{ |attr| %w(_id id updated_at created_at deleted_at).include? attr.name }.each do |attr| -%>
      :<%= attr.name %>,
<% end -%>
    ]
  end

  def show_attrs
    [
<% attributes.reject{ |attr| attr.name == 'deleted_at' }.each do |attr| -%>
      :<%= attr.name %>,
<% end -%>
    ]
  end

  def form_attrs
    [
<% attributes.reject{ |attr| %w(_id id updated_at created_at deleted_at).include? attr.name }.each do |attr| -%>
      :<%= attr.name %>,
<% end -%>
    ]
  end
end
<% end -%>

