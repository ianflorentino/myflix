Myflix::Application.routes.draw do
  
  root to: 'pages#front'

  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'videos#home'
  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'
  get '/register', to: 'users#new'
  get '/my_queue', to: 'queue_items#index'

  resources :queue_items, only: [:create, :destroy]
  resources :users, except: [:destroy]
  resources :categories, only: [:show]
  resources :videos, only: [:show] do
    collection do
      get :search, to: 'videos#search'
    end
    resources :reviews, only: [:create, :destroy]
  end
end