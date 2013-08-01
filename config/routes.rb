Echoes::Application.routes.draw do


  resources :emails


  resources :contacts


  devise_for :users 

  match 'home', :to=>'pages#index'
  get "messages/message_error", as: 'm_error'

  get 'pages/example'

  resources :tags
  resources :messages
  
namespace :api do
   devise_scope :user do
      post 'signin' => 'sessions#create', :as => 'signin'
      delete 'signout' => 'sessions#destroy', :as => 'signout'
      post 'signup' => 'registrations#create', :as => 'register'
    end
      post 'setstage' => 'users#set_stage'
      get 'getstage' => 'users#get_stage'
      post 'updatemail' => 'update_email#set_email'
      post 'mailsync' => 'sync#retrieve_mail'
      post 'sendmail' => 'send#send_mail'
      post 'upload' => 'upload#create'
  end


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'pages#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
