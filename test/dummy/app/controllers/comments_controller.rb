require 'iord/controller'
require 'iord/nested'
require 'iord/json'

class CommentsController < ApplicationController
  include Iord::Controller
  include Iord::Nested
  include Iord::Json

  def index_attrs
    %i(author_name)
  end
end

