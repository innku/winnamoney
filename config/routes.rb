ActionController::Routing::Routes.draw do |map|
  map.resources :payments

  map.resources :addresses

  map.resources :payment_notifications

  map.resources :stores

  map.resources :users
  map.resources :orders, :new => {:express => :get}, :collection => {:success => :get} do |order|
    order.resources :payments
  end
  
  map.resources :cart_items
  
  map.resources :carts do |cart|
    cart.resources :addresses
  end
  
  map.resource  :session
  map.resources :products
  map.resources :cities
  map.resources :states
  map.resources :categories
  map.resources :subcategories
  map.resources :tags
  
  map.home '/', :controller => 'stores', :action => 'index', :index_action => 'redirect_to_store'
  
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.register  '/register', :controller => 'stores', :action => 'new'
  map.login     '/login', :controller => 'sessions', :action => 'new'
  map.shop     '/shop', :controller => 'stores', :action => 'show'
  map.home     '/home', :controller => 'site', :action => 'home'
  map.news     '/news', :controller => 'site', :action => 'news'
  map.company     '/company', :controller => 'site', :action => 'company'
  map.oportunity     '/oportunity', :controller => 'site', :action => 'oportunity'
  map.logout    '/logout', :controller => 'sessions', :action => 'destroy'
  map.forgot    '/forgot',                    :controller => 'users',     :action => 'forgot'
  map.reset     'reset/:reset_code',          :controller => 'users',     :action => 'reset'
  map.contact   '/contact', :controller => 'site', :action => 'contact', :method => :post
  
end
