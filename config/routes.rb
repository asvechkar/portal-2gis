Portal2gis::Application.routes.draw do

  get 'positions/level' => 'positions#level'
  get 'debts/floating' => 'debts#floating'
  get 'employees/get_groups_by_branch_id/:id' => 'employees#get_groups_by_branch_id'
  get 'incomes/get_orders_by_client_id/:id' => 'incomes#get_orders_by_client_id'
  get 'portal/get_incomes_by_month/:month' => 'portal#get_incomes_by_month'

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
