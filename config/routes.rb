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
  
  get 'index' => 'home#index'
  get 'terms' => 'home#terms'
  get 'privacy' => 'home#privacy'
  get 'blog' => 'home#blog'

  devise_for :users, controllers: { registrations: "registrations" }
  devise_scope :user do
    put 'update_card', :to => 'registrations#update_card'
  end
    
  get ':uid/edit/:context' => 'users#edit'
  patch ':uid/edit' => 'users#update'
  get ':uid/thanks' => 'users#show'

  resources :messages
  
  get ':uid' => 'messages#new', :constraints => { :uid => /.+@.+\..*/ }
  get ':uid' => 'messages#new', :constraints => { :uid => /[0][x].*/ } 
  get ':uid' => 'messages#new'

  root :to => 'home#index'
  
end
