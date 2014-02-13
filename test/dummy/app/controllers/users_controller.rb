require 'iord/controller'

Admin ||= Module.new

class UsersController < ApplicationController
  include Iord::Controller

  resource_namespace Admin
end

