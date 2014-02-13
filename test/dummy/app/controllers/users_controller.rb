require 'iord/controller'

Admin ||= Module.new

class UsersController < ApplicationController
  include Iord::Controller

  set_resource_namespace Admin
end

