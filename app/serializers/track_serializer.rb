class TrackSerializer < ActiveModel::Serializer
  attributes :id, :name, :artist, :image, :preview, :spotify_id


  def play_track
    object.play_track
  end

  def pause_track
    object.pause_track
  end

end
