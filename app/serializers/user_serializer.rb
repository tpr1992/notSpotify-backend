class UserSerializer < ActiveModel::Serializer
  attributes :id, :display_name, :user_photo, :followers, :spotify_id, :spotify_link
end
