class Api::V2::TracksController < ApplicationController
  # def self.new_from_spotify_track(spotify_track)
  #   Track.new(
  #     spotify_id: spotify_track.id,
  #     name: spotify_track.name,
  #     artist: spotify_track.artists[0].name,
  #     image: spotify_track.album.images[0]["url"],
  #     preview: spotify_track.preview_url
  #   )
  # end
  #
  # def self.create_from_spotify_track(spotify_track)
  #   track = self.new_from_spotify_track(spotify_track)
  #   track.save
  #   track
  # end

  # @@sdk.connect.devices[0].playback.methods

  # RSpotify::Track.search('thriller').first.audio_features.danceability
  # RSpotify::Album.new_releases
  # RSpotify::Album.new_releases.first.popularity
  # RSpotify::Artist.search('bob dylan')
  # RSpotify::Playlist.browse_featured
  # RSpotify::Playlist.search('jazz')
  # RSpotify::Recommendations.available_genre_seeds
  # RSpotify::Recommendations.generate(seed_tracks: ['0c6xIDDpzE81m2q797ordA'], seed_genres: ['jazz'], seed_artists: ['4NHQUGzhtTLFvgF5SZesLK'], target_energy: 1.0)
  # RSpotify::User.find('1271062927').recently_played
  # RSpotify::Track.search('like a rolling stone').first.audio_features
  # https://www.rubydoc.info/github/guilhermesad/rspotify/master/RSpotify/Recommendations

  @@sdk

  def oauth
    @accounts = Spotify::Accounts.new
    body = {
       # client_id: @accounts.instance_variable_get(:@client_id),
       client_id: ENV['SPOTIFY_CLIENT_ID'],
       # client_secret: @accounts.instance_variable_get(:@client_secret),
       client_secret: ENV['SPOTIFY_CLIENT_SECRET'],
       # redirect_uri: @accounts.instance_variable_get(:@redirect_uri),
       redirect_uri: ENV['SPOTIFY_REDIRECT_URI'],
       grant_type: "authorization_code",
       code: params[:code]
     }
     request = HTTParty.post("https://accounts.spotify.com/api/token", body: body)
     response = request.parsed_response.with_indifferent_access
     @session = Spotify::Accounts::Session.new(@accounts, response[:access_token], response[:expires_in], response[:refresh_token], response[:scope])
     @@sdk = Spotify::SDK.new(@session)
     @spotify_user = User.find_or_create_by(display_name: @@sdk.me.info.display_name, spotify_link: @@sdk.me.info.external_urls[:spotify], followers: @@sdk.me.info.followers, spotify_id: @@sdk.me.info.uri, user_photo: @@sdk.me.info.images[0].url)
     # spotify_user = RSpotify::User.new(@@sdk.me.info.to_h)

     # @@spotify_user = RSpotify::User.find(@@sdk.me.info.id)

     # byebug
  end

  def get_currently_playing
    @track = Track.new(name: @@sdk.connect.devices[0].playback.item.name, artist: @@sdk.connect.devices[0].playback.artist.name, image: @@sdk.connect.devices[0].playback.item.album.images[0].url, preview: @@sdk.connect.devices[0].playback.item.preview_url, spotify_id: @@sdk.connect.devices[0].playback.item.id)
    # @track = @@sdk.connect.devices[0].playback.item.name
    render json: @track
    # @@sdk.connect.devices[0].playback.artist
    # render json: @@sdk.connect.devices[0].playback.artist
  end

  def get_playlists
    # if @@sdk.valid?
      # @playlists = RSpotify::User.find(@@sdk.me.info.id).playlists
      @playlists = RSpotify::User.find('1271062927').playlists.as_json
      # byebug
      render json: @playlists
    # end
  end

  def browse_featured_playlists
    @featured_playlists = RSpotify::Playlist.browse_featured.as_json
    render json: @featured_playlists
  end

  def search_tracks
    @results = RSpotify::Track.search(params[:query])
    @artist_results = RSpotify::Artist.search(params[:query])
    # byebug
    render json: @results.map {|result| result.as_json} && @artist_results.map {|result| result.as_json}
  end

  def play_track
      @@sdk.connect.devices[0].resume!
        # @@sdk.connect.devices[0].play!({
        #   uri: "spotify:track:5ChkMS8OtdzJeqyybCc9R5",
        #   position_ms: 0
        #   })
  end

  def pause_track
      @@sdk.connect.devices[0].pause!
  end

  def next_track
    @@sdk.connect.devices[0].next!
  end

  def prev_track
    @@sdk.connect.devices[0].previous!
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

  def search
    s_tracks = RSpotify::Track.search(params[:q])
    @tracks = s_tracks.map do |s_track|
      Track.new_from_spotify_track(s_track)
    end
    render json: @tracks
  end

  def top_100
    s_tracks = RSpotify::Playlist.find("1271062927","0LrGhnGD40YhKdQPgAdsoM").tracks
    @tracks = s_tracks.map do |s_track|
      Track.new_from_spotify_track(s_track)
    end
    render json: @tracks
    puts @tracks
  end

end
