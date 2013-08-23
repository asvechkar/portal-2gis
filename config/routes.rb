Portal2gis::Application.routes.draw do
  resources :positions

  resources :levels
  resources :cities

  devise_for :users, :controllers => { :registrations => 'registrations', :sessions => 'sessions', :passwords => 'passwords' }
  root 'portal#index'
end
