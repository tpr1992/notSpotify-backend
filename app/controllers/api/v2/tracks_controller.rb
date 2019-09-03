class Api::V2::TracksController < ApplicationController

  # RSpotify::Recommendations.available_genre_seeds
  # RSpotify::Recommendations.generate(seed_tracks: ['0c6xIDDpzE81m2q797ordA'], seed_genres: ['jazz'], seed_artists: ['4NHQUGzhtTLFvgF5SZesLK'], target_energy: 1.0)
  # RSpotify::User.find('1271062927').recently_played
  # https://www.rubydoc.info/github/guilhermesad/rspotify/master/RSpotify/Recommendations

  @@sdk
  # byebug
  def oauth
    @accounts = Spotify::Accounts.new
    body = {
       client_id: ENV['SPOTIFY_CLIENT_ID'],
       client_secret: ENV['SPOTIFY_CLIENT_SECRET'],
       redirect_uri: ENV['SPOTIFY_REDIRECT_URI'],
       grant_type: "authorization_code",
       code: params[:code]
     }
     request = HTTParty.post("https://accounts.spotify.com/api/token", body: body)
     response = request.parsed_response.with_indifferent_access
     @session = Spotify::Accounts::Session.new(@accounts, response[:access_token], response[:expires_in], response[:refresh_token], response[:scope])
     @@sdk = Spotify::SDK.new(@session)
     @spotify_user = User.find_or_create_by(display_name: @@sdk.me.info.display_name, spotify_link: @@sdk.me.info.external_urls[:spotify], followers: @@sdk.me.info.followers, spotify_id: @@sdk.me.info.uri, user_photo: @@sdk.me.info.images[0].url)
     # byebug
  end

  def get_currently_playing
    @track = Track.new(name: @@sdk.connect.devices[0].playback.item.name, artist: @@sdk.connect.devices[0].playback.artist.name, image: @@sdk.connect.devices[0].playback.item.album.images[0].url, preview: @@sdk.connect.devices[0].playback.item.preview_url, spotify_id: @@sdk.connect.devices[0].playback.item.id)
    render json: @track
  end

  def get_playlists
      @playlists = RSpotify::User.find('1271062927').playlists.as_json
      render json: @playlists
  end

  def browse_featured_playlists
    @featured_playlists = RSpotify::Playlist.browse_featured.as_json
    render json: @featured_playlists
  end

  def search_tracks
    @results = RSpotify::Track.search(params[:query])
    @artist_results = RSpotify::Artist.search(params[:query])
    @album_results = RSpotify::Album.search(params[:query])
    track_results = @results.map {|result| result.as_json}
    artist_results = @artist_results.map {|result| result.as_json}
    album_results = @album_results.map {|result| result.as_json}
    all_results = artist_results[0..2] + track_results + album_results
    render json: all_results
  end

  def index
    @tracks = Track.all
    render json: @tracks
  end

  def random
    s_tracks = RSpotify::Playlist.browse_featured.last.tracks
    @tracks = s_tracks.map do |s_track|
      Track.new_from_spotify_track(s_track)
    end
    render json: @tracks
  end

end
