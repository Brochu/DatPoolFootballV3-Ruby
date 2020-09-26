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
  resources :poolers, only: [:new, :create]
end
