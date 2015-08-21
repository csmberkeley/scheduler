Rails.application.routes.draw do

  devise_for :users
  #Set root to ensure devise works
  root "homes#index"
  get "/courses" => "courses#index"
  get "/courses/:id" => "courses#show", as: :course
  get "/sections" => "sections#index"
  get "/sections/:id" => "sections#show", as: :section
  get "/offers/:id" => "offers#show", as: :offer
  get "/new_offer" => "offers#new", as: :new_offer
  post "/offers" => "offers#create"
  delete "/offers/delete/enrollment/:id" => "offers#destroy", as: :delete_offer
  post "/create_response" => "offers#create_response", as: :create_response
  get "/enrollments/:id/switch-section" => "enrollments#switch_section", as: :switch_section
  get "/sections/make-switch/:old_id/:new_id" => "sections#make_switch", as: :make_switch
  delete "/comments/:id" => "comments#destroy", as: :delete_comment
  delete "/replies/:id" => "replies#destroy", as: :delete_reply

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
