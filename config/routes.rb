Rails.application.routes.draw do
  resources :invoices
  resources :categories
  resources :projects
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'projects#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'


  get 'projects_collaborate', to: 'projects#index_collaborate'
  get 'projects/:id/invoice', to: 'invoices#invoice_project', as: 'invoice_project'
  post 'projects/:id/start', to: 'tracks#start'
  post 'projects/:id/stop', to: 'tracks#stop'
  post 'projects/:id/pause', to: 'tracks#pause'
  post 'projects/:id/resume', to: 'tracks#resume'
  post 'projects/:project_id/tracks', to: 'tracks#create'
  patch 'projects/:project_idtracks/:id', to: 'tracks#update'

  delete 'tracks/:id' => 'tracks#destroy'

  resources :projects do
    resources :tracks, only: [:update, :create]
    resources :labels, shallow: true
  end
  resources :tracks, only: [:start, :stop, :pause, :resume, :destroy]
  resources :charts

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
