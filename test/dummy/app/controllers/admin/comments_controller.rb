require 'iord/controller'
require 'iord/nested'
require 'iord/json'

module Admin
  class CommentsController < ApplicationController
    include Iord::Controller
    include Iord::Nested

    defaults parent_models: [Product]

    def index_attrs
      %i(author_name)
    end
  end
end

