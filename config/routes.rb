Portal2gis::Application.routes.draw do

  get 'reports/index'
  get 'reports/planfact'
  post 'reports/recalc_planfact'
  get 'reports/planfact/:id' => 'reports#planfact'
  get 'positions/level' => 'positions#level'
  get 'debts/floating' => 'debts#floating'
  get 'employees/get_groups_by_branch_id/:id' => 'employees#get_groups_by_branch_id'
  get 'incomes/get_orders_by_client_id/:id' => 'incomes#get_orders_by_client_id'
  get 'orders/wizard' => 'orders#wizard', :as => 'new_deal'
  get 'support' => 'portal#support'


  resources :factors
  resources :plancents
  resources :debts
  resources :orders do
    collection do
      post :set_continue
    end
  end
  resources :plans
  resources :groups
  resources :branches do
    get :groups_list, on: :member
    get :employees_list, on: :member
  end

  resources :employees do
    resources :userifications
    get :clients_list, on: :member
  end
  resources :clients do
    get :orders_list, on: :member
  end
  resources :positions
  resources :levels
  resources :cities
  resources :uploads
  resources :roles
  resources :incomes
  resources :averagebills
  resources :eventlogs
  resources :members
  resources :transaction_orders, only: [:new, :create]
  resources :wizard, only: [:index] do
    collection do
      get :clients
      get :current_orders
      get :continue_orders
      get :debts
      get :plans
    end
  end

  devise_for :users, controllers: { registrations: 'registrations', sessions: 'sessions', passwords: 'passwords', confirmations: 'confirmations', unlocks: 'unlocks' }
  root 'portal#index'
end
