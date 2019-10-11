Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/interno', as: 'rails_admin'

  localized do
    root to: "home#index"
    get 'home/index'

    devise_for :users, controllers: { registrations: 'registrations', sessions: 'sessions' }
    devise_for :admins, only: :sessions, controllers: { sessions: 'admin/sessions' }

    resources :tours, only: [:index, :show] do
      get :availability_and_price, on: :member
    end
    resources :events, only: [:index, :show]
    resources :special_deals, only: [:index, :show]
    resources :hotels, only: [:index, :show] do
      get :availability, on: :member
    end
    resources :institutionals, only: [:show]
    resources :transportation, only: [:index, :show]
    resources :categories, only: [:index, :show]
    resources :testimonials, only: [:create]
    resources :carts, only: [:update] do
      get :add_to_cart, on: :collection
      get :additional_information, on: :collection
      get :payment, on: :collection
      get :confirmation, on: :collection
      get :remove_from_cart, on: :member
      post :check_promocode, on: :collection
      post :charge, on: :member
    end
    resources :blogs, only: [:index]

    resources :personas, only: [:index] do
      resources :persona_day_by_days, only: [:index]
    end

    get :search, :to => 'search#results'

    get '/autocomplete/search_history' => 'autocomplete#search_history'
  end

  scope 'pt-br', :locale => 'pt-BR' do
    get '/' => 'home#old_routes_index'
    get '/loja' => 'tours#old_routes_index'
    get '/loja/:id' => 'categories#show'
    get '/servico/:id' => 'tours#old_routes_show'
    get '/:url' => 'application#old_routes_general'
    get '/blog/:id/(:name)' => 'blogs#show'
  end

  scope 'en-us', :locale => 'en' do
    get '/' => 'home#old_routes_index'
    get '/loja' => 'tours#old_routes_index'
    get '/loja/:id' => 'categories#show'
    get '/servico/:id' => 'tours#old_routes_show'
    get '/:url' => 'application#old_routes_general'
    get '/blog/:id/(:blogger_url)' => 'blogs#show'
  end

  get '/:url' => 'application#old_routes_general'

end
