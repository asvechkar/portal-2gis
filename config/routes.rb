Portal2gis::Application.routes.draw do
  resources :plans
  resources :groups
  resources :branches
  resources :employees
  # resources :users
  resources :clients
  resources :positions
  resources :levels
  resources :cities
  get '/users/', to: 'users#index'

  devise_for :users, :controllers => { :registrations => 'registrations', :sessions => 'sessions', :passwords => 'passwords' }
  root 'portal#index'
end
