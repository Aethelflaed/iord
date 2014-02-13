require 'iord/controller'

module Admin
  class UsersController < ApplicationController
    include Iord::Controller

    self.resource_namespace = Admin
  end
end

