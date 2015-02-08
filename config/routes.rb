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
  
  mount StripeEvent::Engine => '/stripe'
  
  match 'index' => 'home#index', via: :get
  match 'terms' => 'home#terms', via: :get
  match 'privacy' => 'home#privacy', via: :get

  devise_for :users, controllers: { registrations: "registrations" }
  devise_scope :user do
    put 'update_card', :to => 'registrations#update_card'
  end
  resources :users
    
  match ':uid/edit/:context' => 'users#edit', via: :get
  match ':uid/edit' => 'users#update', via: :put
  match ':uid/thanks' => 'users#show', via: :get

  resources :messages
  
  match ':uid' => 'messages#new', via: :get, :constraints => { :uid => /.+@.+\..*/ }
  match ':uid' => 'messages#new', via: :get, :constraints => { :uid => /[0][x].*/ } 
  match ':uid' => 'messages#new', via: :get

  root :to => 'home#index'
  
end
