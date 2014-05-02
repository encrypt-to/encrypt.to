Encryptto::Application.routes.draw do
  
  # api
  namespace :api do
    namespace :v1 do
      resources :keyserver do
        collection do
          get 'lookup'
        end
      end
    end
  end
  
  match 'index' => 'home#index', via: :get
  match 'terms' => 'home#terms', via: :get
  match 'privacy' => 'home#privacy', via: :get

  devise_for :users
  
  resources :users
  resources :leads
  match 'sign_up' => 'leads#new', via: :get
    
  match ':uid/edit' => 'users#edit', via: :get
  match ':uid/edit' => 'users#update', via: :put

  resources :messages
  
  match ':uid' => 'messages#new', via: :get, :constraints => { :uid => /.+@.+\..*/ }
  match ':uid' => 'messages#new', via: :get, :constraints => { :uid => /[0][x].*/ } 
  match ':uid' => 'messages#new', via: :get

  root :to => 'home#index'

end
