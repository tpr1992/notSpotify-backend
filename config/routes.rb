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
      resources :tracks do
        collection do
          get :top_100
          get :random
          get :search
        end
    end
  end
end
end
