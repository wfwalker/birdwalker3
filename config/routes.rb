ActionController::Routing::Routes.draw do |map|
  map.resources :posts

  # wfw root URL
  map.connect '', :controller => 'bird_walker', :action => 'index'

  # resources
  map.resources :counties
  map.resources :sightings, :collection => { :edit_individual => :post, :update_individual => :put }
  map.resources :photos, :collection => { :recent_gallery => :get, :recent_gallery_rss => :get }
  map.resources :trips, :collection => { :list_biggest => :get }
  map.resources :states
  map.resources :locations, :collection => { :locations_near => :get }
  map.resources :families
  map.resources :species, :singular => :species_instance, :collection => { :life_list => :get, :photo_life_list => :get, :photo_to_do_list => :get }
  
  # wfw special map for year list
  map.connect 'species/year_list/:year', :controller => 'species', :action => 'year_list'

  # map.resources :fish, :singular => :fish_instance, :new => {:preview => :post}, :member => {:fillet => :post}

  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  map.connect 'trips/:year/:month/:day.:format', :controller => 'trips', :action => 'show_by_date'


  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'  
  
  map.connect 'webapp.manifest', :controller =>'bird_walker', :action => 'webapp_manifest'
  map.connect 'webapp.manifest.json', :controller =>'bird_walker', :action => 'webapp_manifest'
  map.connect 'manifest.webapp', :controller =>'bird_walker', :action => 'webapp_manifest'
end
