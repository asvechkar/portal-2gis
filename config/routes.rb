Portal2gis::Application.routes.draw do
  resources :branches

  resources :employees
  resources :users
  resources :clients
  resources :positions
  resources :levels
  resources :cities

  devise_for :users, :controllers => { :registrations => 'registrations', :sessions => 'sessions', :passwords => 'passwords' }
  root 'portal#index'
end
