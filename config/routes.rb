Rails.application.routes.draw do
  resources :playlists
  namespace :api do
    namespace :v1 do
      resources :user_tracks
      resources :albums
      resources :users
      resources :artists
      resources :tracks do
        collection do
          get :top_100
          get :random
          get :search
        end
      end
    end
    namespace :v2 do
    #   resources :users do
    #     get '/login', to: "users#spotify_create"
    #     post '/user', to: "users#create"
    #   end
    # end
    get "/oauth", to: "tracks#oauth"
    get "/play_track", to: "tracks#play_track"
    get "/pause_track", to: "tracks#pause_track"
    get "/next_track", to: "tracks#next_track"
    get "/prev_track", to: "tracks#prev_track"
    get "/get_currently_playing", to: "tracks#get_currently_playing"
    get "/get_playlists", to: "tracks#get_playlists"
    post "/search_tracks", to: "tracks#search_tracks"



      resources :tracks do
        collection do
          get :get_currently_playing
          get :play_track
          get :pause_track
          get :next_track
          get :prev_track
          get :search_tracks
        end
    end
    resources :users do
      collection do
        get :index
      end
    end
  end
end
end
