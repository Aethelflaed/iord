require 'iord/controller'
require 'iord/nested'
require 'iord/json'

module Admin
  class CommentsController < ApplicationController
    include Iord::Controller
    include Iord::Nested

    parent_model Product

    def index_attrs
      %i(author_name)
    end
  end
end

