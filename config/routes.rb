Portal2gis::Application.routes.draw do
  devise_for :users, :controllers => { :registrations => 'registrations', :sessions => 'sessions', :passwords => 'passwords' }
  root 'portal#index'
end
