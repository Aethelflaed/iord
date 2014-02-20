class Comment
  include Mongoid::Document

  embedded_in :commentable, polymorphic: true

  field :author_name
  field :content
end

