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

  @@sdk

  def oauth
    @accounts = Spotify::Accounts.new
    test = {
       client_id: @accounts.instance_variable_get(:@client_id),
       client_secret: @accounts.instance_variable_get(:@client_secret),
       redirect_uri: @accounts.instance_variable_get(:@redirect_uri),
       grant_type: "authorization_code",
       code: params[:code]
     }
     request = HTTParty.post("https://accounts.spotify.com/api/token", body: test)
     response = request.parsed_response.with_indifferent_access
     @session = Spotify::Accounts::Session.new(@accounts, response[:access_token], response[:expires_in], response[:refresh_token], response[:scope])
     @@sdk = Spotify::SDK.new(@session)
     byebug
  end

  def get_currently_playing
    @track = Track.new(name: @@sdk.connect.devices[0].playback.item.name, artist: @@sdk.connect.devices[0].playback.artist.name, image: @@sdk.connect.devices[0].playback.item.album.images[0].url, preview: @@sdk.connect.devices[0].playback.item.preview_url, spotify_id: @@sdk.connect.devices[0].playback.item.id)
    # @track = @@sdk.connect.devices[0].playback.item.name
    render json: @track
    # @@sdk.connect.devices[0].playback.artist
    # render json: @@sdk.connect.devices[0].playback.artist

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
