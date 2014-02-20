require 'iord/controller'
require 'iord/nested'

class ManagersController < ApplicationController
  include Iord::Controller
  include Iord::Nested
end

