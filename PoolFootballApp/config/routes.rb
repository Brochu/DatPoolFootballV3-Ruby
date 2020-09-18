Rails.application.routes.draw do
  get 'sessions/omniauth'
  resources :users
  resources :picks
  resources :poolers
  resources :pools
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/' => 'sessions#login'

  get '/auth/:provider/callback' => 'sessions#omniauth'
  get 'auth/failure' => '/'
end
