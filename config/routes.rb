ActionController::Routing::Routes.draw do |map|

  map.resources :activities
  map.resources :documents
  map.resources :employees
  map.resources :feedbacks
  map.resources :recruits,
    :member => {
      :advance  => :put,
      :reject   => :put,
      :decline  => :put,
    }

  map.resources :user_sessions

  map.login  'login',  :controller => 'user_sessions', :action => 'new'
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'
  map.oops   'oops',   :controller => 'application',   :action => 'oops'

  map.root :controller => :recruits


  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
