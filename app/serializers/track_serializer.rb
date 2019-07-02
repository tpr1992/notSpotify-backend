class TrackSerializer < ActiveModel::Serializer
  attributes :id, :name, :artist, :image, :preview, :spotify_id

  def get_currently_playing
    object.get_currently_playing
  end

  def get_playlists
    object.get_playlists
  end

  def search_tracks
    object.search_tracks
  end

  def play_track
    object.play_track
  end

  def pause_track
    object.pause_track
  end

  def next_track
    object.next_track
  end

  def prev_track
    object.prev_track
  end

end
