require 'iord/controller'

module Admin
  class UsersController < ApplicationController
    include Iord::Controller

    resource_namespace Admin
  end
end

