class Api::V1::TracksController < ApplicationController

# spotify_token = RestClient.post("https://accounts.spotify.com/api/token",{"grant_type": "client_credentials"}, {"Authorization": "Basic #{client_token}"})
# parsed_token = JSON.parse(spotify_token)

  def index
    @tracks = Track.all
    render json: @tracks
  end

  def show
    @track = Track.find(params[:id])
    render json: @track
  end

  def top_100
    s_tracks = RSpotify::Playlist.find('1271062927', '0LrGhnGD40YhKdQPgAdsoM').tracks
    @tracks = s_tracks.map do |s_track|
      Track.new_from_spotify_track(s_track)
    end
    render json: @tracks
  end

  def search
    s_tracks = RSpotify::Track.search(params[:q])
    @tracks = s_tracks.map do |s_track|
      Track.new_from_spotify_track(s_track)
    end
render json: @tracks
end

  # def random
  #     s_tracks = RSpotify::Playlist.browse_featured.first.tracks
  #     @tracks = s_tracks.map do |s_track|
  #       Track.new_from_spotify_track(s_track)
  #     end
  # render json: @tracks
  # end


end
