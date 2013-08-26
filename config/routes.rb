Portal2gis::Application.routes.draw do
  resources :debts
  get 'positions/level' => 'positions#level'
  resources :orders
  resources :plans
  resources :groups
  resources :branches
  resources :employees
  resources :clients
  resources :positions
  resources :levels
  resources :cities

  get '/users/', to: 'users#index'

  devise_for :users, :controllers => { :registrations => 'registrations', :sessions => 'sessions', :passwords => 'passwords' }
  root 'portal#index'
end
