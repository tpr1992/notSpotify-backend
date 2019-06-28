require 'rspotify'

class Track < ApplicationRecord
  # belongs_to :artist
  # belongs_to :album

  def self.new_from_spotify_track(spotify_track)
    Track.new(
      spotify_id: spotify_track.id,
      name: spotify_track.name,
      artist: spotify_track.artists[0].name,
      image: spotify_track.album.images[0]["url"],
      preview: spotify_track.preview_url
    )
    # puts Track
  end

  def self.create_from_spotify_track(spotify_track)
    track = self.new_from_spotify_track(spotify_track)
    track.save
    track
  end

end
