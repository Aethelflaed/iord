require 'iord/controller'
require 'iord/nested'
require 'iord/json'
require 'iord/hooks'

class CommentsController < ApplicationController
  include Iord::Controller
  include Iord::Nested
  include Iord::Json
  include Iord::Hooks

  def index_attrs
    %i(author_name)
  end
end

