require 'iord/controller'
require 'iord/nested'
require 'iord/json'

class SubcommentsController < ApplicationController
  include Iord::Controller
  include Iord::Nested
  include Iord::Json

  defaults resource_class: Comment

  def index_attrs
    %i(author_name)
  end
end

