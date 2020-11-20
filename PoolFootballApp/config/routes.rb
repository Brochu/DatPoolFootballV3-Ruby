Rails.application.routes.draw do
  # For now we disable the resources routes, to be re-activated for admin side
  # resources :users
  # resources :picks
  # resources :poolers
  # resources :pools
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Sessions base routes to login and logout
  get '/' => 'sessions#login'
  get '/sessions/goodbye' => 'sessions#goodbye'

  # Auth results routing
  get '/auth/:provider/callback' => 'sessions#omniauth'
  get 'auth/failure' => '/'

  # Client facing resources
  resources :pools, only: [:index]
  resources :poolers, only: [:index, :new, :create, :show, :edit, :update]

  get '/picks' => 'picks#index'

  get '/picks/new/:season/:week' => 'picks#new', as: :new_pick_path
  post '/picks' => 'picks#create'

  get '/picks/:id' => 'picks#show', as: :pick
  get '/picks/search/:season/:week' => 'picks#show_week', as: :search_pick
end
