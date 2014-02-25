class Comment
  include Mongoid::Document

  embedded_in :commentable, polymorphic: true

  embeds_many :comments, as: :commentable

  field :author_name
  field :content
end

