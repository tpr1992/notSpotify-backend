Rails.application.routes.draw do
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


      resources :tracks do
        collection do
          get :top_100
          get :play_track
          get :pause_track
          get :random
          get :search
        end
    end
  end
end
end
