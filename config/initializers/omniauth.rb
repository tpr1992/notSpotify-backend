require 'rspotify/oauth'
#
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, ENV["SPOTIFY_CLIENT_ID"], ENV["SPOTIFY_CLIENT_SECRET"], scope: 'user-read-email playlist-read-private playlist-modify-private user-read-private user-read-currently-playing playlist-modify-public user-library-read user-read-recently-played user-top-read user-read-playback-state user-library-modify streaming'
end
