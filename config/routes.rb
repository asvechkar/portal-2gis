Portal2gis::Application.routes.draw do

  get 'positions/level' => 'positions#level'
  resources :debts
  resources :orders
  resources :plans
  resources :groups
  resources :branches
  resources :employees
  resources :clients
  resources :positions
  resources :levels
  resources :cities
  resources :uploads
  resources :roles
  resources :incomes
  resources :averagebills
  resources :eventlogs

  get '/users/' => 'users#index', :as => 'users'
  get '/users/:id/edit' => 'users#edit', :as => 'edit_user'
  get '/users/:id' => 'users#show', :as => 'user'
  patch '/users/:id(.:format)' => 'users#update'

  devise_for :users, :controllers => { :registrations => 'registrations', :sessions => 'sessions', :passwords => 'passwords' }
  root 'portal#index'
end
