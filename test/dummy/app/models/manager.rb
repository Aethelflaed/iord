class Manager
  include Mongoid::Document

  embedded_in :managable, polymorphic: true

  field :firstname
  field :lastname
end

