Birdwalker3::Application.routes.draw do
  resources :posts

  match '' => 'bird_walker#index'

  resources :counties

  resources :sightings do
    collection do
      post :edit_individual
      put :update_individual
    end
  end

  resources :photos do
    collection do
      get :recent_gallery
      get :recent_gallery_rss
    end
  end

  resources :trips do
    collection do
      get :list_biggest
    end
  end

  resources :states

  resources :locations do
    collection do
      get :locations_near
    end
  end

  resources :families

  resources :species do
    collection do
      get :life_list
      get :photo_life_list
      get :photo_to_do_list
  end
end

  # # resources
  # map.resources :families
  # map.resources :species, :singular => :species_instance,

  match 'species/year_list/:year' => 'species#year_list'
  match ':controller/service.wsdl' => '#wsdl'
  match 'trips/:year/:month/:day.:format' => 'trips#show_by_date'
  match 'photos/:year/:month/:day/:abbreviation/:originalfilename.:format' => 'photos#show_by_date'
  match 'species/abbrev/:abbreviation.:format' => 'species#show_by_abbreviation'
  match '/:controller(/:action(/:id))'
  match 'webapp.manifest' => 'bird_walker#webapp_manifest'
  match 'webapp.manifest.json' => 'bird_walker#webapp_manifest'
  match 'manifest.webapp' => 'bird_walker#webapp_manifest'
end
