Portal2gis::Application.routes.draw do

  get 'positions/level' => 'positions#level'
  get 'debts/floating' => 'debts#floating'
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
  resources :members

  devise_for :users, :controllers => { :registrations => 'registrations', :sessions => 'sessions', :passwords => 'passwords' }
  root 'portal#index'
end
