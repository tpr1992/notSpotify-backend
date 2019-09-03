Rails.application.routes.draw do
  resources :playlists
  namespace :api do
    namespace :v2 do
      get "/oauth", to: "tracks#oauth"
      get "/get_playlists", to: "tracks#get_playlists"
      get "/browse_featured_playlists", to: "tracks#browse_featured_playlists"
      post "/search_tracks", to: "tracks#search_tracks"
      resources :tracks do
        collection do
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
