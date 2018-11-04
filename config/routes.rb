Rails.application.routes.draw do
  get 'sessions/new'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :groups do
  	member do
  		
  		get :join
  		get :tracker
  		get :portrait
  		get :compas
      get :leaveGroup
  	end
  	collection do
  		post :appCreate
      get :appIndex
      post :appEdit
  	end
  end

  resources :users do
    collection do
      post :appCreate
      
      get :getUser
      post :appEdit

    end
    member do
     get :groop
    end
  end
 root 'groups#index'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  get    '/logout',  to: 'sessions#destroy'

  

end
