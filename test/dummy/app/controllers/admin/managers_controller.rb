require 'iord/controller'
require 'iord/nested'

module Admin
  class ManagersController < ApplicationController
    include Iord::Controller
    include Iord::Nested

    parent_model Product
  end
end

