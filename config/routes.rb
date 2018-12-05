Rails.application.routes.draw do
  get 'errors/404'
  get 		'sessions/new'
  root 		'home#index'
  get 		'users/new'
  get     'edit',       to: 'users#edit'
  post    'edit',       to: 'users#update' 
  get     'users',      to: 'users#index'
  get 		'/signup',		to: 'users#new'
  post 		'/signup',		to: 'users#create'
  get 		'/login',		  to: 'sessions#new'
  post 		'/login',		  to: 'sessions#create'
  get 	'/logout',		to: 'sessions#destroy'
  get 'messages',       to: 'conversations#index'
  get 'inbox',			to: 'conversations#inbox'
  get 'conversations',	to: 'conversations#create'

  # for elasticsearch/searchkick
  #get 'search',         to: 'search#search'

  resources :users
  resources :books
  resources :account_activations, only: [:edit]
  resources :conversations do
    resources :messages
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :books do
    member do
      delete :delete_cover_image
      delete :delete_condition_image
    end
  end

  resources :books do
    collection do
      get :autocomplete 
    end
  end
end
