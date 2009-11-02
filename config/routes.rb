ActionController::Routing::Routes.draw do |map|
  map.resources :payment_notifications

  map.resources :stores

  map.resources :users do |user|
    user.resource :payment_information, :controller => 'payment_information'
  end
  
  map.resource  :session
  map.resources :products
  map.resources :cities
  map.resources :states
  map.resources :categories
  map.resources :subcategories
  map.resources :tags
  
  map.home '/', :controller => 'sessions', :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.signup '/registro', :controller => 'users', :action => 'new'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  
  
end
