require 'resque/server'
Generala::Application.routes.draw do

  namespace :kf do
    resources :useraction_histories
    resources :user_notices
    resources :sorts do
      collection do
        get 'for_deep4'
      end
    end
    resources :sicknesses
    resources :global_configs do
      collection do
        get 'feedback'
      end
    end
    resources :doctors
    resources :diary_attachments
    resources :diaries
    resources :course_knowledge_attachments
    resources :courses do
      collection do
        get 'order_items'
        get 'dupe_index'
        get 'dupe'
        get 'showtext'
      end
    end
    resources :course_knowledge_media
    resources :course_item_types
    resources :course_forms
    resources :course_indices
    resources :course_todos
    resources :course_froms
    resources :course_knowledges
    resources :course_user_favs
    resources :sort_types
    resources :useraction_history_types
    resources :statuses
    resources :pipes
    resources :course_knowledgets
  end

  match '/cs/'  => 'kfzspage#main'


  mount WeixinRailsMiddleware::Engine, at: "/"

  resources :cms_sorts do
    collection do
      get :manage
      # required for Sortable GUI server side actions
      post :rebuild
    end
  end

  get "app_shop_order/index"
  get "app_shop_order/open"
  get "app_shop_order/show"
  get "app_shop_order/edit"
  get "app_shop_order/list"
  get "app_product_order/index"
  get "app_product_order/show"
  get "app_product_order/update"
  get "app_activity/index"
  get "templages/importdata"
  get "templages/importdianpu"
  get "templages/testweixin"
  get "templages/test_sortble"

  get "yixue/train"
  get "yixue/review"
  get "yixue/init_api"
  get "yixue/call_api"
  # match "yixue/call_api" => "yixue#call_api"
  match ':appnum/yixue/:action' => 'yixue#:action'

  resources :templages

  get "kfzsadmin/index"


  get "dashboard/index"
  get "dashboard/search_activity"
  get "dashboard/search_shop"
  get "dashboard/search_product"
  get "dashboard/sort_list"
  get "dashboard/sort_edit"
  get "dashboard/sort_add"
  get "dashboard/sort_remove"
  get "dashboard/fake_login"

  get "manage/appstate"
  get "project/index"
  get "project/product"
  get "project/example"
  get "project/about"
  get "project/detail"

  get "mobile/content"
  get "mobile/codeRedirect"


  # d.nowapp.cn
  match ':appnum'  => 'mobile#download' , :constraints => {:appnum => /[0-9]+/ , :subdomain => "d"}
  # a.nowapp.cn
  match ':actionid'  => 'mobile#codeRedirect' , :constraints => {:actionid => /[0-9A-Za-z]+/ , :subdomain => "a"}
  # s.nowapp.cn
  match ':contentid'  => 'mobile#paegRedirect' , :constraints => {:contentid => /[0-9]+/ , :subdomain => "s"}
  namespace :webapps do
    match ':appnum/webapp/:action'  => 'webapp#:action' , :constraints => {:appnum => /[0-9]+/}
    match ':appnum'  => 'webapp#main' , :constraints => {:appnum => /[0-9]+/}

    match ':appnum/pcmain/:action/:module_id'  => 'pcmain#:action' , :constraints => {:appnum => /[0-9]+/,:module_id => /[0-9]+/}
    match ':appnum/news/:action/:module_id'  => 'news#:action' , :constraints => {:appnum => /[0-9]+/,:module_id => /[0-9]+/}
    match ':appnum/product/:action/:module_id'  => 'product#:action' , :constraints => {:appnum => /[0-9]+/,:module_id => /[0-9]+/}
    match ':appnum/coupon/:action/:module_id'  => 'coupon#:action' , :constraints => {:appnum => /[0-9]+/,:module_id => /[0-9]+/ } #, :conditions => { :subdomain => "s" } 
    match ':appnum/shop/:action/:module_id'  => 'shop#:action' , :constraints => {:appnum => /[0-9]+/,:module_id => /[0-9]+/}
    match ':appnum/more/:action/:module_id'  => 'more#:action' , :constraints => {:appnum => /[0-9]+/,:module_id => /[0-9]+/}
    match ':appnum/photo/:action/:module_id'  => 'photo#:action' , :constraints => {:appnum => /[0-9]+/,:module_id => /[0-9]+/}
    match ':appnum/activity/:action/:module_id'  => 'activity#:action' , :constraints => {:appnum => /[0-9]+/,:module_id => /[0-9]+/}
    match ':appnum/:action'  => 'framework#:action'  , :constraints => {:appnum => /[0-9]+/}
    # match ':appnum/app'  => 'framework#index'  , :constraints => {:appnum => /[0-9]+/}
  end

  # admin.nowapp.cn
  namespace :admins do
    match '/app_news/:module_id/:action'  => 'app_news#:action' , :constraints => {:module_id => /[0-9]+/}
    match '/app_product/:module_id/:action'  => 'app_product#:action', :constraints => {:module_id => /[0-9]+/}
    #场地产品
    match '/app_area_product/:module_id/:action'  => 'app_area_product#:action', :constraints => {:module_id => /[0-9]+/}

    match '/app_photo/:module_id/:action'  => 'app_photo#:action', :constraints => {:module_id => /[0-9]+/}
    match '/app_coupon/:module_id/:action'  => 'app_coupon#:action' , :constraints => {:module_id => /[0-9]+/}
    match '/app_shop/:module_id/:action'  => 'app_shop#:action', :constraints => {:module_id => /[0-9]+/}
    match '/app_user/:module_id/:action'  => 'app_user#:action', :constraints => {:module_id => /[0-9]+/}
    match '/app_poi/:module_id/:action'  => 'app_poi#:action', :constraints => {:module_id => /[0-9]+/}
    match '/app_activity/:module_id/:action'  => 'app_activity#:action', :constraints => {:module_id => /[0-9]+/}
    match '/app_pcmain/:module_id/:action'  => 'app_pcmain#:action', :constraints => {:module_id => /[0-9]+/}
    match '/info_weibo/:module_id/:action'  => 'info_weibo#:action', :constraints => {:module_id => /[0-9]+/}
    match '/info_weibo/:action'  => 'info_weibo#:action'
    match '/info_weixin/:module_id/:action'  => 'info_weixin#:action', :constraints => {:module_id => /[0-9]+/}

    match '/sys_user/:module_id/:action'  => 'sys_user#:action', :constraints => {:module_id => /[0-9]+/}
    match '/sys_status/:module_id/:action'  => 'sys_status#:action', :constraints => {:module_id => /[0-9]+/}
    match '/sys_status/:action'  => 'sys_status#:action', :constraints => {:module_id => /[0-9]+/}
    match '/sys_outlink/:action'  => 'sys_outlink#:action'
    match '/sys_appconfig/:action'  => 'sys_appconfig#:action'
    match '/sys_sortconfig/:action'  => 'sys_sortconfig#:action'
    # wang
    match '/sys_delivery/:module_id/:action'  => 'sys_delivery#:action', :constraints => {:module_id => /[0-9]+/}
    match '/sys_signup/:module_id/:action'  => 'sys_signup#:action', :constraints => {:module_id => /[0-9]+/}
  
    match '/sys_sportlog/:module_id/:action'  => 'sys_sportlog#:action', :constraints => {:module_id => /[0-9]+/}
    match '/sys_repairlog/:module_id/:action'  => 'sys_repairlog#:action', :constraints => {:module_id => /[0-9]+/}
    match '/sys_coupon_order/:module_id/:action'  => 'sys_coupon_order#:action', :constraints => {:module_id => /[0-9]+/}


    match '/sys_apply/:module_id/:action'  => 'sys_apply#:action', :constraints => {:module_id => /[0-9]+/}
    match '/sys_feedback/:module_id/:action'  => 'sys_feedback#:action', :constraints => {:module_id => /[0-9]+/}
    match '/sys_product_order/:module_id/:action'  => 'sys_product_order#:action', :constraints => {:module_id => /[0-9]+/}
    match '/sys_buy_order/:module_id/:action'  => 'sys_buy_order#:action', :constraints => {:module_id => /[0-9]+/}
    match '/sys_order_report/:module_id/:action'  => 'sys_order_report#:action', :constraints => {:module_id => /[0-9]+/}
    match '/sys_user_sort/:module_id/:action'  => 'sys_user_sort#:action', :constraints => {:module_id => /[0-9]+/}
    match '/sys_user_consignee/:module_id/:action'  => 'sys_user_consignee#:action', :constraints => {:module_id => /[0-9]+/}
    match '/sys_comment/:module_id/:action'  => 'sys_comment#:action', :constraints => {:module_id => /[0-9]+/}
    match '/sys_statistics/:module_id/:action'  => 'sys_statistics#:action', :constraints => {:module_id => /[0-9]+/}
    # 管理员功能
    match '/tools_qrcode/:action'  => 'tools_qrcode#:action'
    match '/tools_adminuser/:module_id/:action'  => 'tools_adminuser#:action'


  end

  # test controllers
  namespace :test do
    match '/life/:action'  =>'life#:action'
   # match '/life/:module_id/:action'  => 'life#:action' , :constraints => {:module_id => /[0-9]+/}
  end

  namespace :webapis do
    #match "/api/:action/:url_value" =>"wiki#:action" , :constraints => {:url_value => /.*/}
    match '/wiki/:action'  => 'wiki#:action'
  end
  #
  #match 'api(/:url_value)'  => "webapis::wiki#intercept", :constraints => {:url_value => /[\w.\/]+/}
  #match 'oauth(/:url_value)'  => "webapis::wiki#intercept", :constraints => {:url_value => /[\w.\/]+/}
  match 'eceditor/:action'  => 'eceditor#:action'


  match 'api(/:url_value)'  => "api#index", :constraints => {:url_value => /[\w.\/]+/}
  match 'oauth(/:url_value)'  => "api#index", :constraints => {:url_value => /[\w.\/]+/}

  # 微博插件
  match "syncs/:type/new" => "syncs#new", :as => :sync_new
  match "syncs/:type/callback" => "syncs#callback", :as => :sync_callback
  match "syncs/:type/add_status" => "syncs#add_status" , :as => :sync_add_status

  mount Resque::Server, :at => "/resque"
  devise_for :admin_users
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  root :to => 'project#index'


  # require 'genghis'
  # mount Genghis::Server.new, :at => '/genghis'

end
