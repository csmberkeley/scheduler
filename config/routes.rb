Rails.application.routes.draw do

  devise_for :users
  #Set root to ensure devise works
  root "homes#index"
  #get "/courses" => "courses#index"
  #get "/courses/:id" => "courses#show", as: :course
  resources :courses

  get "/attendances" => "attendances#index", as: :student_attendance_index
  post "/attendances" => "attendances#create", as: :student_attendance_create
  post "/attendances/checkin" => "attendances#checkin", as: :student_attendance_checkin
  patch "/attendances/mentor/set_pass/:id" => "attendances#set_pass", as: :mentor_set_pass
  patch "/attendances/mentor/assign_attendance/:id" => "attendances#set_status", as: :mentor_set_attendance_status
  post "/attendances/mentor/assign_attendance/:id" => "attendances#set_status"
  post "/attendances/mentor/approve_absence/:id" => "attendances#approve", as: :mentor_attendance_approve
  post "/attendances/mentor/reject_absence/:id" => "attendances#reject", as: :mentor_attendance_reject
  get "/attendances/mentor" => "attendances#mentor_index", as: :mentor_attendance_index
  get "/attendances/jmentor/:id" => "attendances#mentor_show", as: :junior_mentor_attendance
  get "/attendances/smentor/:id" => "attendances#mentor_show_senior", as: :senior_mentor_attendance
  get "/attendances/:id" => "attendances#show", as: :student_attendance


  # get "/sections" => "sections#index"
  # get "/sections/:id" => "sections#show", as: :section
  resources :sections
  get "/sections/make-switch/:old_id/:new_id" => "sections#make_switch", as: :make_switch
  get "/sections/drop/:enroll_id" => "sections#drop", as: :drop_section

  #enrolling into a course and section
  resources :enrollments
  post "/enrollments/new" => "enrollments#create"
  patch "/enrollments/:id/edit" => "enrollments#update"
  delete "/enrollments/delete/:id" => "enrollments#destroy_admin", as: :admin_destroy_enroll
  get "/offers/:id" => "offers#show", as: :offer
  get "/new_offer" => "offers#new", as: :new_offer
  post "/offers" => "offers#create"
  delete "/offers/delete/enrollment/:id" => "offers#destroy", as: :delete_offer
  post "/create_response" => "offers#create_response", as: :create_response
  get "/enrollments/:id/switch-section" => "enrollments#switch_section", as: :switch_section

  delete "/comments/:id" => "comments#destroy", as: :delete_comment
  delete "/replies/:id" => "replies#destroy", as: :delete_reply
  post "/replies/accept/:id" => "replies#accept", as: :accept_reply
  post "/replies/deny/:id" => "replies#deny", as: :deny_reply

  resources :jenrolls
  post "/jenrolls/mentorenroll" => "jenrolls#mentor_enroll", as: :mentor_enroll
  post "/jenrolls/new" => "jenrolls#create"
  patch "/jenrolls/:id/edit" => "jenrolls#update"
  get "/jenrolls/:id/roster" => "jenrolls#roster", as: :jenroll_roster

  resources :senrolls
  patch "/senrolls/:id/edit" => "senrolls#update"
  get "/senrolls/:id/roster" => "senrolls#roster", as: :senroll_roster

  #admin stuff
  get "/admin/students" => "admins#index", as: :students_index
  get "/admin/new-student" => "admins#new_student", as: :admin_new_student
  post "/admin/create-student" => "admins#create_student", as: :admin_create_student
  get "/admin/students/:id" => "admins#edit_student", as: :admin_edit_student
  patch "/admin/students/:id" => "admins#update_student", as: :admin_update_student
  post "/admin/students/add_course/:user_id" => "admins#add_course", as: :admin_add_course
  get "/admin/courses" => "courses#admin_index", as: :admin_course_index
  post "/admin/send_email" => "admins#send_email", as: :admin_send_email
  #resources :settings, only:[:index, :update]
  get "/settings" => "settings#index",  as: :settings
  post "/settings" => "settings#update"
  get "/admin/manage_sections" => "admins#manage_sections", as: :manage_sections
  match 'users/:id' => 'users#destroy', :via => :delete, :as => :admin_destroy_user
  
  get "/admin/manage_section/add/:id" => "admins#new_student_to_section", as: :new_student_to_section
  post "/admin/manage_section/add/:id" => "admins#add_student_to_section"
  post "/admin/manage_sections/drop/:id" => "admins#drop_student_from_section", as: :drop_student_from_section


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
