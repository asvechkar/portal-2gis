Portal2gis::Application.routes.draw do

  resources :plancents

  get 'reports/index'
  get 'reports/planfact'
  get 'reports/planfact/:id' => 'reports#planfact'
  get 'positions/level' => 'positions#level'
  get 'debts/floating' => 'debts#floating'
  get 'employees/get_groups_by_branch_id/:id' => 'employees#get_groups_by_branch_id'
  get 'incomes/get_orders_by_client_id/:id' => 'incomes#get_orders_by_client_id'
  get 'orders/wizard' => 'orders#wizard', :as => 'new_deal'
  get 'support' => 'portal#support'


  resources :debts
  resources :orders do
    collection do
      post :set_continue
    end
  end
  resources :plans
  resources :groups
  resources :branches
  resources :employees do
    resources :userifications
  end
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

  devise_for :users, :controllers => { :registrations => 'registrations', :sessions => 'sessions', :passwords => 'passwords', :confirmations => 'confirmations', :unlocks => 'unlocks' }
  root 'portal#index'
end
