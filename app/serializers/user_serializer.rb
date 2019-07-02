class UserSerializer < ActiveModel::Serializer
  attributes :id, :display_name, :user_photo, :followers, :spotify_id, :spotify_link
  # has_many :tracks
end
