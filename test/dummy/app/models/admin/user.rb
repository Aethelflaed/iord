module Admin
  class User
    include Mongoid::Document

    field :firstname
    field :lastname
  end
end

