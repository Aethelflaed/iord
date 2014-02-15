<% if namespaced? -%>
require_dependency "<%= namespaced_file_path %>/application_controller"
<% end -%>
require 'iord/controller'

<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
  include Iord::Controller

  def index_attrs
    super
  end

  def show_attrs
    super
  end

  def form_attrs
    super
  end
end
<% end -%>

