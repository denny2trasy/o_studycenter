ElStudycenter::Application.routes.draw do

  resources :messages, :only => %w{index create ask_msgs}
  get 'ask_msgs' => 'messages#ask_msgs', :as => :ask_msgs

  resources :broadcasts, :only => %w{index create } do
    get :qr, :on => :collection
    get :helper, :on => :collection
  end

  resources :forums
  resources :issues

  get 'home' => 'home#index', :as => :home

  resources :ehome,  :only => %w{show index}
  resources :lessons, :only => %w{show index}
  resources :scenarios, :only => %w{show index}
  resources :chinacaches, :only => %w{show index}
  resources :thinkingcaps, :only => %w{show index}

  resources :study_records, :only => %w{create show_records}  do
    get :show_records,:on => :collection
  end
  resources :course_packages, :only => %w{index new show} do
    post :activate, :on => :collection 
    put :current, :on => :member
  end
  
  resources :contact , :only =>%w{index salon jidebao acgem requirements} do
    get :salon,:on => :collection
    get :jidebao,:on => :collection
    get :requirements,:on => :collection
    get :acgem,:on => :collection
    get :about_us,:on => :collection
    get :introductions, :on => :collection
  end
  
  resources :download ,:only =>%w{file } do
    get :file ,:on=>:collection
  end
  
  namespace :admin do
    resources :base
    resources :slides
    resources :users, :only => [:index, :show] do
      member do 
        post "set_course_package_user_expired_at"
      end
    end
    resources :questions do
      post :set_question_prompt, :on => :member
      resources :answers
    end
    resources :customers do
      member do
        post "set_customer_company_name"
        post "set_customer_short_name"
      end
    end
    resources :course_packages do
      member do
        post "set_item_position"
        post "set_course_package_name"
        post "set_course_package_valid_for"
        post "set_course_package_description"
        post "set_course_package_eleutian_course"
        post "set_course_package_thinkingcap_program"
        post "set_register_code_desc"
        post "set_course_package_customer_id"
        post "set_scenario_name"
        post "set_scenario_position"
        post "set_scenario_show_scenario_id"
        post "set_third_content_name"
        post "set_third_content_position"
        post "set_third_content_show_content_id"
        post "set_third_content_show_link"
        post "set_third_content_thinkingcap_course"
        post "set_item_group_position"
        post "set_item_group_name"
        post "set_item_group_course_type"
        post "set_item_group_quiz_level"
        post "set_course_package_course_type"
        get  "copy"
      end
    end
    resources :item_groups
    resources :register_codes
    resources :items
    resources :oenglishs do
      member do
        post "set_oenglish_name"
        post "set_oenglish_video_url"
        post "set_oenglish_show_oenglish_id"
      end
    end
    resources :webex_users
    resources :notices do
      post :set_notice_title, :on => :member
      post :set_notice_content, :on => :member
      post :set_notice_display, :on => :member
    end
    resources :course_packages
    resources :quizzes do
      post :set_quiz_prompt, :on => :member
      post :set_quiz_position, :on => :member
      post :set_quiz_level, :on => :member
      post :set_quiz_q_type, :on => :member
      post :set_quiz_sounds, :on => :member
      post :set_quiz_images, :on => :member

    end
    
    resources :sub_quizzes
    resources :sub_quiz_answers
    resources :records
    
  end
  
  namespace :admin do
    resources :schedules do
      collection do
        get 'download'
        post 'upload'
        get 'get_course'
        post 'resize'
        post 'move'
        get 'nnew'
        get 'customer_list'
        get 'customer_schedule'
        get "login"
        get "set_meeting"
        get "schedule_meeting"
        get "up_schedule"
      end
    end
    resources :statistics
    resources :mail_templates do
      collection do
        post 'set_mail_template_name'
        post 'set_mail_template_variables'
        post 'set_mail_template_in_use'
        post 'set_mail_template_used_by'
        post 'set_mail_template_description'
      end
      get :preview, :on =>:member
    end
    
    resources :mail_records do
      collection do
        
      end
    end
  end
  resources :mail_services
  
  resources :redirects
  namespace :teacher do
    resources :broadcasts
    resources :webexs
  end
  resources :replaces do
    collection do
      get 'sencha'
      post 'take'
    end
  end

  resources :webexs do
    collection do
      get 'enroll'
      get 'month_schedule'
      get 'get_enroll_id'
      post 're_enroll'
    end
  end
  
  resources :partners do
    collection do
      get 'enroll'
      get 'month_schedule'
    end
  end
  
  resources :partner_apis do
    collection do
      post 'register'
      post 'activate'
      post 'login'
    end
  end
  
  resources :ppts 
  resources :homeworks do
    collection do
      get 'generate'
      post 'submit'
      get 'result'
      get 'drag'
      get 'list'
    end
  end
  
  resources :courses do
    collection do
      get 'get_items'
    end
  end
  
  resources :progress do
    collection do
      get 'group_study_records'
      get 'group_webex_records'
      get 'group_test_records'
    end
  end
  
  resources :progress_records
  
  resources :contents do
    collection do
      get 'get_items'
    end
  end

  
  
  #get "study", :controller => "scenario_studies", :action => "index", :path_prefix => ":type/lesson/:id/:lesson_flag"
  get ":type/lesson/:id/:lesson_flag"=>"scenario_studies#index"
  
  get "password" => 'user/passwords#edit', :as => :password

  get 'signup' => 'user/profiles#new', :as => :signup
  get 'signup/:id' => 'user/profiles#show'
  get 'profile' => 'user/profiles#edit', :as => :profile 
  get 'profile/validate_login' => 'user/profiles#validate_login'
  get 'profile/validate_mail' => 'user/profiles#validate_mail'

  get 'signin' => 'user/sessions#new', :as => :signin
  get 'signin/:id' => 'user/sessions#show'
  get 'sso' => 'user/sessions#sso', :as => :sso
  post 'sso_back' => "user/sessions#sso_back", :as => :sso_back
  get 'schedules' => 'user/schedules#index', :as => :schedules
  
  get 'user/schedules/get_my_course' => 'user/schedules#get_my_course'
  get 'user/schedules/get_tc_course' => 'user/schedules#get_tc_course'
  get 'requirements' => 'contact#requirements'
  
  
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
  root :to => "home#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
