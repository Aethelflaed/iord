require 'iord/controller'
require 'iord/nested'

module Admin
  class ManagersController < ApplicationController
    include Iord::Controller
    include Iord::Nested

    defaults parent_models: [Product]
  end
end

