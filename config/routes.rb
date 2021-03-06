Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create]
      resources :games, only: [:create]
      post '/login', to: 'auth#create'
      get '/profile', to: 'users#profile'
      post '/join', to: 'games#join'
      post '/guess', to: 'games#guess'
      post '/start', to: 'games#start'
    end
  end
  mount ActionCable.server => '/cable'
end
