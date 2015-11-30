# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20150816065056) do

  create_table "act_action_types", :force => true do |t|
    t.string    "name",      :limit => 50, :default => "",                    :null => false
    t.text      "descption",                                                  :null => false
    t.datetime  "create_at",               :default => '2000-01-01 00:00:00', :null => false
    t.timestamp "update_at",                                                  :null => false
  end

  create_table "act_activity_orders", :force => true do |t|
    t.integer   "project_info_id",                  :default => 0,                     :null => false
    t.integer   "user_info_id",                     :default => 0,                     :null => false
    t.integer   "act_status_type_id",               :default => 0,                     :null => false
    t.integer   "cms_activity_id",                  :default => 0,                     :null => false
    t.boolean   "is_checkin",                       :default => false,                 :null => false
    t.string    "nick_name",          :limit => 50, :default => "",                    :null => false
    t.string    "apply_code",         :limit => 50, :default => "",                    :null => false
    t.datetime  "created_at",                       :default => '2000-01-01 00:00:00', :null => false
    t.timestamp "updated_at",                                                          :null => false
  end

  create_table "act_applies", :force => true do |t|
    t.integer "project_info_id",               :default => 0
    t.string  "name",            :limit => 50, :default => ""
    t.string  "int1_des",                      :default => ""
    t.string  "int2_des",                      :default => ""
    t.string  "int3_des",                      :default => ""
    t.string  "int4_des",                      :default => ""
    t.string  "int5_des",                      :default => ""
    t.string  "text1_des",                     :default => ""
    t.string  "text2_des",                     :default => ""
    t.string  "text3_des",                     :default => ""
    t.string  "text4_des",                     :default => ""
    t.string  "text5_des",                     :default => ""
    t.string  "text6_des",                     :default => ""
    t.string  "text7_des",                     :default => ""
    t.string  "text8_des",                     :default => ""
    t.string  "text9_des",                     :default => ""
    t.string  "text10_des",                    :default => ""
    t.text    "col_order"
  end

  create_table "act_buy_order_logs", :force => true do |t|
    t.integer   "act_buy_order_id",                  :default => 0
    t.integer   "project_info_id",                   :default => 0,   :null => false
    t.timestamp "created_at",                                         :null => false
    t.integer   "payment_type",                      :default => 0,   :null => false
    t.integer   "act_status_type_id",                :default => 0,   :null => false
    t.float     "must_price",         :limit => 10,  :default => 0.0, :null => false
    t.text      "remarks",                                            :null => false
    t.text      "json_property"
    t.string    "title",              :limit => 500
    t.integer   "cms_sort_id"
  end

  create_table "act_buy_orders", :force => true do |t|
    t.integer  "shop_content_id"
    t.integer  "project_companie_id",                :default => 0,                     :null => false
    t.integer  "project_info_id",                    :default => 0,                     :null => false
    t.integer  "user_info_id",                       :default => 0,                     :null => false
    t.integer  "order_number",                                                          :null => false
    t.integer  "cms_content_id",                     :default => 0,                     :null => false
    t.integer  "cms_sort_id"
    t.string   "title",               :limit => 500
    t.float    "product_price",       :limit => 10,  :default => 0.0,                   :null => false
    t.float    "fare_price",          :limit => 10,  :default => 0.0,                   :null => false
    t.float    "must_price",          :limit => 10,  :default => 0.0,                   :null => false
    t.integer  "payment_type",                       :default => 0,                     :null => false
    t.integer  "act_status_type_id",                 :default => 0,                     :null => false
    t.integer  "user_consignee_id",                  :default => 0,                     :null => false
    t.text     "remarks",                                                               :null => false
    t.string   "home_num",            :limit => 50,  :default => ""
    t.string   "card_id",             :limit => 50,  :default => ""
    t.integer  "people_num",                         :default => 0
    t.datetime "check_time",                         :default => '1999-01-01 00:00:00'
    t.datetime "departure_time",                     :default => '1999-01-01 00:00:00'
    t.datetime "about_time",                         :default => '1999-01-01 00:00:00'
    t.integer  "sex",                 :limit => 1,   :default => 1
    t.string   "come_from",           :limit => 50,  :default => ""
    t.integer  "age",                                :default => 0
    t.integer  "source",                             :default => 0
    t.text     "json_property"
    t.integer  "send_type",                          :default => 0,                     :null => false
    t.integer  "product_num",                        :default => 0,                     :null => false
    t.string   "username",            :limit => 50,  :default => ""
    t.string   "phone",               :limit => 50,  :default => ""
    t.string   "address",             :limit => 250, :default => ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "act_buy_orders", ["order_number"], :name => "order_number"
  add_index "act_buy_orders", ["shop_content_id"], :name => "shop_content_id"
  add_index "act_buy_orders", ["user_info_id", "updated_at"], :name => "user_info_id"

  create_table "act_buy_people_orders", :force => true do |t|
    t.datetime  "created_at",                      :default => '2000-01-01 00:00:00', :null => false
    t.timestamp "updated_at",                                                         :null => false
    t.integer   "project_info_id",                 :default => 0,                     :null => false
    t.integer   "act_buy_order_id",                :default => 0,                     :null => false
    t.string    "username",         :limit => 50,  :default => "",                    :null => false
    t.string    "phone",            :limit => 50,  :default => "",                    :null => false
    t.string    "card_id",          :limit => 50,  :default => "",                    :null => false
    t.integer   "sex",              :limit => 1,   :default => 1,                     :null => false
    t.integer   "age",                             :default => 0,                     :null => false
    t.string    "address",          :limit => 250, :default => "",                    :null => false
  end

  create_table "act_coupon_orders", :force => true do |t|
    t.integer   "project_info_id",                      :default => 0,                     :null => false
    t.integer   "user_info_id",                         :default => 0,                     :null => false
    t.integer   "act_status_type_id",                   :default => 0,                     :null => false
    t.integer   "cms_content_coupon_id",                :default => 0,                     :null => false
    t.string    "nick_name",             :limit => 50,  :default => "",                    :null => false
    t.text      "apply_code",            :limit => 255,                                    :null => false
    t.datetime  "created_at",                           :default => '2000-01-01 00:00:00', :null => false
    t.timestamp "updated_at",                                                              :null => false
  end

  add_index "act_coupon_orders", ["updated_at", "cms_content_coupon_id"], :name => "updated_at"
  add_index "act_coupon_orders", ["user_info_id", "cms_content_coupon_id"], :name => "Index 2"

  create_table "act_groupon_orders", :force => true do |t|
    t.integer   "project_info_id",                      :default => 0,                     :null => false
    t.integer   "user_info_id",                         :default => 0,                     :null => false
    t.integer   "act_status_type_id",                   :default => 0,                     :null => false
    t.integer   "cms_content_groupon_id",               :default => 0,                     :null => false
    t.string    "nick_name",              :limit => 50, :default => "",                    :null => false
    t.string    "apply_code",             :limit => 50, :default => "",                    :null => false
    t.datetime  "created_at",                           :default => '2000-01-01 00:00:00', :null => false
    t.timestamp "updated_at",                                                              :null => false
  end

  create_table "act_limitcoupon_orders", :force => true do |t|
    t.integer   "project_info_id",                          :default => 0,                     :null => false
    t.integer   "user_info_id",                             :default => 0,                     :null => false
    t.integer   "act_status_type_id",                       :default => 0,                     :null => false
    t.integer   "cms_content_limitcoupon_id",               :default => 0,                     :null => false
    t.string    "nick_name",                  :limit => 50, :default => "",                    :null => false
    t.string    "apply_code",                 :limit => 50, :default => "",                    :null => false
    t.datetime  "created_at",                               :default => '2000-01-01 00:00:00', :null => false
    t.timestamp "updated_at",                                                                  :null => false
  end

  create_table "act_logs", :force => true do |t|
    t.integer   "act_action_type_id", :default => 0, :null => false
    t.text      "description",                       :null => false
    t.integer   "project_app_id",     :default => 0, :null => false
    t.integer   "user_info_id",       :default => 0, :null => false
    t.timestamp "update_at",                         :null => false
  end

  create_table "act_option_types", :force => true do |t|
    t.string "name",        :limit => 50, :default => ""
    t.string "cnname",      :limit => 50, :default => ""
    t.string "description", :limit => 50, :default => ""
  end

  create_table "act_options", :force => true do |t|
    t.integer "act_apply_id",                     :default => 0,  :null => false
    t.integer "act_option_type_id",               :default => 0,  :null => false
    t.integer "order_level",                      :default => 0,  :null => false
    t.string  "type_name",          :limit => 50, :default => "", :null => false
    t.string  "text1",              :limit => 50,                 :null => false
    t.string  "description",        :limit => 50,                 :null => false
    t.string  "cms_sort_type_id",   :limit => 50,                 :null => false
  end

  create_table "act_plan_changelogs", :force => true do |t|
    t.integer   "cms_info_plan_id", :default => 0
    t.integer   "project_info_id",  :default => 0
    t.integer   "user_info_id",     :default => 0
    t.string    "action",           :default => ""
    t.datetime  "created_at",       :default => '2000-01-01 00:00:00'
    t.timestamp "updated_at"
  end

  create_table "act_ship_orders", :force => true do |t|
    t.integer  "project_info_id",                  :default => 0, :null => false
    t.integer  "user_info_id",                     :default => 0, :null => false
    t.integer  "cms_content_id",                   :default => 0, :null => false
    t.string   "title",             :limit => 500
    t.integer  "user_consignee_id",                :default => 0, :null => false
    t.text     "remarks"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "act_signup_orders", :force => true do |t|
    t.integer  "project_info_id",                :default => 0, :null => false
    t.integer  "user_info_id",                   :default => 0, :null => false
    t.integer  "cms_content_id",                 :default => 0, :null => false
    t.string   "title",           :limit => 500
    t.integer  "user_signup_id",                 :default => 0, :null => false
    t.text     "remarks"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "act_status", :force => true do |t|
    t.integer   "user_info_id",               :default => 0,                     :null => false
    t.string    "name",         :limit => 50, :default => "",                    :null => false
    t.string    "descption",    :limit => 50, :default => "",                    :null => false
    t.datetime  "created_at",                 :default => '2000-01-01 00:00:00', :null => false
    t.timestamp "updated_at",                                                    :null => false
  end

  create_table "act_status_types", :force => true do |t|
    t.string    "name",       :limit => 50, :default => "",                    :null => false
    t.text      "descption",                                                   :null => false
    t.datetime  "created_at",               :default => '2000-01-01 00:00:00', :null => false
    t.timestamp "updated_at",                                                  :null => false
  end

  create_table "act_tasks", :force => true do |t|
    t.integer "cms_content_id", :default => 0,  :null => false
    t.integer "user_info_id",   :default => 0,  :null => false
    t.string  "name",           :default => "", :null => false
  end

  create_table "activity_contents_news_contents", :id => false, :force => true do |t|
    t.integer "news_content_id",     :null => false
    t.integer "activity_content_id", :null => false
  end

  create_table "activity_contents_shop_contents", :force => true do |t|
    t.integer "activity_content_id", :null => false
    t.integer "shop_content_id",     :null => false
  end

  create_table "activity_rob", :force => true do |t|
    t.integer  "contentid",        :default => 0,                     :null => false
    t.integer  "isbuying",         :default => 0,                     :null => false
    t.datetime "starttime",        :default => '1990-01-01 00:00:00', :null => false
    t.datetime "endtime",          :default => '1990-01-01 00:00:00', :null => false
    t.integer  "totalquantity",    :default => 0,                     :null => false
    t.integer  "personalquantity", :default => 0,                     :null => false
    t.integer  "integral",         :default => 0,                     :null => false
    t.datetime "useendtime",       :default => '1990-01-01 00:00:00', :null => false
    t.float    "originalfare",     :default => 0.0,                   :null => false
    t.float    "nowfare",          :default => 0.0,                   :null => false
    t.integer  "projectid",        :default => 0,                     :null => false
  end

  create_table "activity_rob_log", :force => true do |t|
    t.integer  "contentid", :default => 0,                     :null => false
    t.integer  "userid",    :default => 0,                     :null => false
    t.datetime "robtime",   :default => '1990-01-01 00:00:00', :null => false
    t.integer  "projectid", :default => 0,                     :null => false
    t.integer  "robnum",    :default => 0,                     :null => false
  end

  create_table "admin_action_logs", :force => true do |t|
  end

  create_table "admin_action_types", :force => true do |t|
  end

  create_table "admin_permissions", :force => true do |t|
    t.string   "action",      :default => "", :null => false
    t.string   "subject",     :default => "", :null => false
    t.string   "description", :default => "", :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "admin_permissions_admin_users", :id => false, :force => true do |t|
    t.integer "admin_permission_id", :null => false
    t.integer "admin_user_id",       :null => false
  end

  add_index "admin_permissions_admin_users", ["admin_permission_id", "admin_user_id"], :name => "index_admin_permissions_users_on_admin_permission_id_and_user_id"
  add_index "admin_permissions_admin_users", ["admin_user_id", "admin_permission_id"], :name => "index_admin_permissions_users_on_user_id_and_admin_permission_id"

  create_table "admin_role_privileges", :force => true do |t|
  end

  create_table "admin_roles", :force => true do |t|
  end

  create_table "admin_user_privileges", :force => true do |t|
  end

  create_table "admin_users", :force => true do |t|
    t.integer  "project_info_id",        :default => 0
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "api_uri_call_configs", :force => true do |t|
    t.string    "name",                 :limit => 100
    t.text      "description"
    t.string    "uri",                  :limit => 100
    t.integer   "project_info_id"
    t.integer   "api_call_uri_sort_id"
    t.text      "configs"
    t.boolean   "enabled",                             :default => true, :null => false
    t.text      "send_config"
    t.datetime  "created_at"
    t.timestamp "updated_at",                                            :null => false
  end

  create_table "api_uri_call_job_error_logs", :force => true do |t|
    t.integer  "api_call_job_id",               :null => false
    t.datetime "created_at",                    :null => false
    t.text     "error",                         :null => false
    t.string   "error_code",      :limit => 50, :null => false
  end

  create_table "api_uri_call_jobs", :force => true do |t|
    t.integer   "project_info_id",                        :null => false
    t.integer   "user_info_id",                           :null => false
    t.integer   "api_uri_call_sort_id",                   :null => false
    t.integer   "api_uri_call_config_id",                 :null => false
    t.text      "call_to_uri",                            :null => false
    t.text      "call_params",                            :null => false
    t.text      "call_result"
    t.integer   "api_web_info_id",                        :null => false
    t.integer   "api_web_info_version_id",                :null => false
    t.integer   "call_count",              :default => 0, :null => false
    t.datetime  "created_at",                             :null => false
    t.timestamp "update_at",                              :null => false
  end

  create_table "api_uri_call_sorts", :force => true do |t|
    t.string   "name",         :limit => 50,                   :null => false
    t.text     "configs",                                      :null => false
    t.string   "desc",         :limit => 50,                   :null => false
    t.text     "send_configs",                                 :null => false
    t.boolean  "enabled",                    :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at",                                   :null => false
  end

  create_table "api_web_info_triggers", :force => true do |t|
    t.string    "name",             :limit => 100,                   :null => false
    t.text      "description"
    t.integer   "project_info_id",                 :default => 0,    :null => false
    t.integer   "api_web_info_id",                                   :null => false
    t.text      "api_version_reg"
    t.string    "call_url",         :limit => 100, :default => ""
    t.text      "condition_exp"
    t.text      "call_before_eval"
    t.text      "call_params"
    t.boolean   "enabled",                         :default => true, :null => false
    t.datetime  "created_at",                                        :null => false
    t.timestamp "updated_at",                                        :null => false
  end

  create_table "api_web_info_version_historys", :force => true do |t|
    t.timestamp "created_at",                                                                 :null => false
    t.integer   "api_web_info_version_id",                                                    :null => false
    t.string    "action_name",                              :limit => 50
    t.float     "api_web_info_version_main_version",                                          :null => false
    t.string    "api_web_info_version_sub_version",         :limit => 50,                     :null => false
    t.float     "api_web_info_version_api_web_info_id",                                       :null => false
    t.boolean   "api_web_info_version_is_default_version",                 :default => false
    t.text      "api_web_info_version_input_maps",                                            :null => false
    t.text      "api_web_info_version_output_maps",                                           :null => false
    t.text      "api_web_info_version_error_maps",                                            :null => false
    t.datetime  "api_web_info_version_created_at"
    t.datetime  "api_web_info_version_updated_at"
    t.boolean   "api_web_info_version_is_handler_delegate"
    t.string    "api_web_info_version_handler_delegate",    :limit => 100
    t.boolean   "api_web_info_version_is_handler_eval",                    :default => true
    t.text      "api_web_info_version_handler_eval"
    t.boolean   "api_web_info_version_is_traces"
    t.text      "api_web_info_version_description"
  end

  create_table "api_web_info_versions", :force => true do |t|
    t.float     "main_version",                                          :null => false
    t.string    "sub_version",         :limit => 50,                     :null => false
    t.float     "api_web_info_id",                                       :null => false
    t.boolean   "is_default_version",                 :default => false
    t.text      "input_maps",                                            :null => false
    t.text      "output_maps",                                           :null => false
    t.text      "error_maps",                                            :null => false
    t.datetime  "created_at"
    t.timestamp "updated_at",                                            :null => false
    t.boolean   "is_handler_delegate"
    t.string    "handler_delegate",    :limit => 100
    t.boolean   "is_handler_eval",                    :default => true
    t.text      "handler_eval"
    t.boolean   "is_traces"
    t.text      "description"
  end

  create_table "api_web_infos", :force => true do |t|
    t.string   "name",                          :limit => 50, :default => ""
    t.string   "display_name",                  :limit => 50, :default => ""
    t.text     "description"
    t.text     "key_words"
    t.integer  "project_info_id",                             :default => 0
    t.string   "uri_resource",                  :limit => 50, :default => ""
    t.boolean  "is_deprecated",                               :default => false
    t.boolean  "is_authorization",                            :default => true
    t.integer  "api_web_info_id",                             :default => 0
    t.string   "type_id",                       :limit => 50, :default => "0"
    t.string   "action_result_type",            :limit => 50, :default => "0"
    t.integer  "is_authentication_type",        :limit => 8
    t.string   "authentication_type",           :limit => 80
    t.text     "authentication_type_params"
    t.boolean  "is_authentication_delegate"
    t.string   "authentication_delegate",       :limit => 80
    t.text     "authentication_delegateParams"
    t.integer  "api_level"
    t.boolean  "is_cache"
    t.string   "cache_type",                    :limit => 80
    t.string   "cache_id",                      :limit => 50
    t.text     "cache_params"
    t.text     "channels"
    t.datetime "created_at"
    t.datetime "updated_at",                                                     :null => false
  end

  add_index "api_web_infos", ["project_info_id", "uri_resource"], :name => "project_info_id", :unique => true

  create_table "api_web_keywords", :force => true do |t|
    t.string   "name",         :limit => 50
    t.string   "display_name", :limit => 50
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "api_web_resources", :force => true do |t|
    t.string   "name",         :limit => 50
    t.string   "display_name", :limit => 50
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "api_web_types", :force => true do |t|
    t.string   "name",         :limit => 50
    t.string   "display_name", :limit => 50
    t.integer  "father_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cms_content_comments", :force => true do |t|
    t.integer   "project_info_id",                 :default => 0,                     :null => false
    t.integer   "user_info_id",                    :default => 0,                     :null => false
    t.integer   "to_user_id",                      :default => 0
    t.integer   "cms_sort_type_id",                :default => 0,                     :null => false
    t.integer   "cms_content_id",                  :default => 0,                     :null => false
    t.integer   "typenum",                         :default => 0,                     :null => false
    t.string    "title",            :limit => 200, :default => "",                    :null => false
    t.text      "content",                                                            :null => false
    t.string    "admin_reply",      :limit => 100, :default => "",                    :null => false
    t.integer   "vote_star",        :limit => 1,   :default => 0
    t.string    "nick_name",        :limit => 50,  :default => "",                    :null => false
    t.string    "longitude",        :limit => 20,  :default => "",                    :null => false
    t.string    "latitude",         :limit => 20,  :default => "",                    :null => false
    t.datetime  "created_at",                      :default => '2000-01-01 00:00:00', :null => false
    t.timestamp "updated_at",                                                         :null => false
    t.integer   "status",                          :default => 0
  end

  add_index "cms_content_comments", ["cms_content_id"], :name => "cms_content_id"

  create_table "cms_content_favs", :force => true do |t|
    t.integer  "user_info_id",   :default => 0,                     :null => false
    t.integer  "cms_content_id", :default => 0,                     :null => false
    t.datetime "created_at",     :default => '2000-01-01 00:00:00', :null => false
  end

  add_index "cms_content_favs", ["user_info_id"], :name => "user_info_id"

  create_table "cms_content_feedbacks", :force => true do |t|
    t.integer   "project_info_id",               :default => 0,                     :null => false
    t.integer   "cms_sort_id",                   :default => 0,                     :null => false
    t.integer   "user_info_id",                  :default => 0,                     :null => false
    t.integer   "type_num",                      :default => 0,                     :null => false
    t.text      "content",                                                          :null => false
    t.string    "contact_info",    :limit => 50,                                    :null => false
    t.boolean   "is_comment",                    :default => false
    t.text      "comment_info"
    t.datetime  "created_at",                    :default => '2000-01-01 00:00:00', :null => false
    t.timestamp "updated_at",                                                       :null => false
  end

  create_table "cms_content_imgs", :force => true do |t|
    t.integer   "project_info_id",                :default => 0,                     :null => false
    t.integer   "cms_content_id",                 :default => 0,                     :null => false
    t.string    "image",           :limit => 100, :default => "",                    :null => false
    t.text      "description",                                                       :null => false
    t.datetime  "created_at",                     :default => '2000-01-01 00:00:00', :null => false
    t.timestamp "updated_at",                                                        :null => false
  end

  add_index "cms_content_imgs", ["cms_content_id"], :name => "cms_content_id"

  create_table "cms_content_product_details", :force => true do |t|
    t.integer   "act_buy_order_id",                                      :default => 0
    t.integer   "product_num",                                           :default => 0
    t.integer   "cms_content_id",                                        :default => 0,                     :null => false
    t.integer   "cms_sort_id",                                           :default => 0,                     :null => false
    t.integer   "project_info_id",                                       :default => 0,                     :null => false
    t.integer   "user_info_id",                                          :default => 0,                     :null => false
    t.integer   "order_level",                                           :default => 0,                     :null => false
    t.string    "title",                                  :limit => 200, :default => "",                    :null => false
    t.text      "abstract",                                                                                 :null => false
    t.text      "content",                                                                                  :null => false
    t.string    "image_cover",                            :limit => 100, :default => "",                    :null => false
    t.integer   "vote_all",                                              :default => 0,                     :null => false
    t.integer   "vote_count",                                            :default => 0,                     :null => false
    t.integer   "comment_count",                                         :default => 0,                     :null => false
    t.integer   "images_count",                                          :default => 0,                     :null => false
    t.integer   "up_count",                                              :default => 0,                     :null => false
    t.integer   "down_count",                                            :default => 0,                     :null => false
    t.integer   "view_count",                                            :default => 0,                     :null => false
    t.boolean   "is_effective",                                          :default => true,                  :null => false
    t.boolean   "is_buy",                                                :default => false,                 :null => false
    t.integer   "cms_info_shop_id",                                      :default => 0,                     :null => false
    t.float     "price_old",                              :limit => 10,  :default => 0.0,                   :null => false
    t.float     "discount",                               :limit => 3,   :default => 0.0,                   :null => false
    t.integer   "apply_type",                                            :default => 0,                     :null => false
    t.integer   "apply_point",                                           :default => 0,                     :null => false
    t.integer   "apply_money",                                           :default => 0,                     :null => false
    t.float     "price",                                  :limit => 10,  :default => 0.0,                   :null => false
    t.datetime  "apply_start_time",                                      :default => '2000-01-01 00:00:00', :null => false
    t.datetime  "apply_end_time",                                        :default => '2000-01-01 00:00:00', :null => false
    t.datetime  "start_time",                                            :default => '2000-01-01 00:00:00', :null => false
    t.datetime  "end_time",                                              :default => '2000-01-01 00:00:00', :null => false
    t.integer   "member_limit",                                          :default => 0,                     :null => false
    t.datetime  "created_at",                                            :default => '2000-01-01 00:00:00', :null => false
    t.timestamp "updated_at",                                                                               :null => false
    t.integer   "p_0"
    t.integer   "p_1"
    t.integer   "p_2"
    t.integer   "p_3"
    t.integer   "p_4"
    t.integer   "cms_content_product_details_lockcfg_id"
  end

  add_index "cms_content_product_details", ["act_buy_order_id"], :name => "act_buy_order_id"

  create_table "cms_content_product_details_lockcfgs", :force => true do |t|
    t.integer   "cms_sort_id",                     :null => false
    t.integer   "cms_content_id",                  :null => false
    t.boolean   "locked",                          :null => false
    t.integer   "order_limit",                     :null => false
    t.integer   "order_now",                       :null => false
    t.date      "date",                            :null => false
    t.integer   "created_source",   :default => 0, :null => false
    t.date      "end_date"
    t.datetime  "created_at",                      :null => false
    t.timestamp "updated_at",                      :null => false
    t.text      "json_property"
    t.integer   "p_0",              :default => 0
    t.integer   "p_1",              :default => 0
    t.integer   "p_2",              :default => 0
    t.integer   "p_3",              :default => 0
    t.integer   "p_4",              :default => 0
    t.integer   "act_buy_order_id"
  end

  create_table "cms_content_share_logs", :force => true do |t|
  end

  create_table "cms_content_share_orders", :force => true do |t|
  end

  create_table "cms_content_share_sorts", :force => true do |t|
  end

  create_table "cms_content_votes", :force => true do |t|
    t.integer  "user_info_id",   :default => 0,                     :null => false
    t.integer  "cms_content_id", :default => 0,                     :null => false
    t.datetime "created_at",     :default => '2000-01-01 00:00:00', :null => false
  end

  create_table "cms_contents", :force => true do |t|
    t.string    "type",                :limit => 50,               :default => "",    :null => false
    t.spatial   "baidu_gps_point",     :limit => {:type=>"point"},                    :null => false
    t.float     "baidu_longitude",     :limit => 13,               :default => 0.0
    t.float     "baidu_latitude",      :limit => 12,               :default => 0.0
    t.integer   "project_info_id",                                 :default => 0,     :null => false
    t.integer   "user_info_id",                                    :default => 0,     :null => false
    t.integer   "cms_sort_type_id",                                :default => 0
    t.integer   "cms_content_info_id",                             :default => 0
    t.integer   "order_level",                                     :default => 0
    t.text      "title",                                                              :null => false
    t.text      "abstract",                                                           :null => false
    t.text      "content",             :limit => 2147483647,                          :null => false
    t.boolean   "is_push",                                         :default => false
    t.string    "image_cover",         :limit => 100,              :default => "",    :null => false
    t.string    "video_url",           :limit => 200,              :default => "",    :null => false
    t.boolean   "is_pushed",                                       :default => false
    t.boolean   "is_show",                                         :default => true
    t.boolean   "is_bigimage",                                     :default => false
    t.integer   "vote_all",                                        :default => 0
    t.integer   "vote_count",                                      :default => 0
    t.integer   "vote_result",         :limit => 1,                :default => 0
    t.integer   "comment_count",                                   :default => 0
    t.integer   "images_count",                                    :default => 0
    t.integer   "up_count",                                        :default => 0
    t.integer   "down_count",                                      :default => 0
    t.integer   "order_count",                                     :default => 0
    t.integer   "view_count",                                      :default => 0
    t.datetime  "created_at",                                                         :null => false
    t.timestamp "updated_at"
    t.integer   "start_flag",          :limit => 2,                :default => 0
    t.integer   "end_flag",            :limit => 2,                :default => 0
  end

  add_index "cms_contents", ["baidu_gps_point"], :name => "baidu_gps_point", :spatial => true
  add_index "cms_contents", ["baidu_longitude", "baidu_latitude"], :name => "baidu_longitude"
  add_index "cms_contents", ["start_flag", "end_flag"], :name => "start_flag"
  add_index "cms_contents", ["type", "project_info_id"], :name => "type"
  add_index "cms_contents", ["user_info_id", "updated_at"], :name => "user_info_id_2"
  add_index "cms_contents", ["user_info_id"], :name => "user_info_id"

  create_table "cms_contents_cms_contents", :force => true do |t|
    t.integer "cms_content_id",        :default => 0, :null => false
    t.integer "cms_father_content_id", :default => 0, :null => false
  end

  create_table "cms_contents_cms_sorts", :id => false, :force => true do |t|
    t.integer "cms_content_id", :default => 0, :null => false
    t.integer "cms_sort_id",    :default => 0, :null => false
  end

  add_index "cms_contents_cms_sorts", ["cms_content_id"], :name => "content"
  add_index "cms_contents_cms_sorts", ["cms_sort_id"], :name => "cms_sort_id"

  create_table "cms_contents_sys_location_infos", :id => false, :force => true do |t|
    t.integer "cms_content_id",       :default => 0, :null => false
    t.integer "sys_location_info_id", :default => 0, :null => false
  end

  add_index "cms_contents_sys_location_infos", ["cms_content_id"], :name => "content"
  add_index "cms_contents_sys_location_infos", ["sys_location_info_id"], :name => "sys_location_info_id"

  create_table "cms_info_activities", :force => true do |t|
    t.integer   "cms_content_id"
    t.boolean   "is_effective",                    :default => true,                  :null => false
    t.integer   "cms_info_shop_id",                :default => 0,                     :null => false
    t.integer   "apply_type",                      :default => 0,                     :null => false
    t.integer   "apply_point",                     :default => 0,                     :null => false
    t.integer   "apply_money",                     :default => 0,                     :null => false
    t.datetime  "apply_start_time",                :default => '2013-01-01 00:00:00', :null => false
    t.datetime  "apply_end_time",                  :default => '2013-01-01 00:00:00', :null => false
    t.datetime  "start_time",                      :default => '2013-01-01 00:00:00', :null => false
    t.datetime  "end_time",                        :default => '2013-01-01 00:00:00', :null => false
    t.integer   "member_limit",                    :default => 0,                     :null => false
    t.integer   "personal_limit",                  :default => 0,                     :null => false
    t.integer   "current_count",                   :default => 0,                     :null => false
    t.string    "address",          :limit => 300, :default => "",                    :null => false
    t.string    "longitude",        :limit => 20,  :default => "",                    :null => false
    t.string    "latitude",         :limit => 20,  :default => "",                    :null => false
    t.datetime  "created_at",                      :default => '2000-01-01 00:00:00', :null => false
    t.timestamp "updated_at",                                                         :null => false
  end

  create_table "cms_info_applies", :force => true do |t|
    t.integer   "int1",            :default => 0,                     :null => false
    t.integer   "int2",            :default => 0,                     :null => false
    t.integer   "int3",            :default => 0,                     :null => false
    t.integer   "int4",            :default => 0,                     :null => false
    t.integer   "int5",            :default => 0,                     :null => false
    t.text      "text1",                                              :null => false
    t.text      "text2",                                              :null => false
    t.text      "text3",                                              :null => false
    t.text      "text4",                                              :null => false
    t.text      "text5",                                              :null => false
    t.text      "text6",                                              :null => false
    t.text      "text7",                                              :null => false
    t.text      "text8",                                              :null => false
    t.text      "text9",                                              :null => false
    t.text      "text10",                                             :null => false
    t.integer   "act_apply_id",    :default => 0,                     :null => false
    t.integer   "user_info_id",    :default => 0,                     :null => false
    t.integer   "project_info_id", :default => 0,                     :null => false
    t.datetime  "created_at",      :default => '2000-01-01 00:00:00', :null => false
    t.timestamp "updated_at",                                         :null => false
  end

  create_table "cms_info_coupons", :force => true do |t|
    t.integer   "cms_content_id"
    t.boolean   "is_effective",                     :default => true,                  :null => false
    t.integer   "cms_info_shop_id",                 :default => 0,                     :null => false
    t.float     "price",             :limit => 10,  :default => 0.0,                   :null => false
    t.float     "price_old",         :limit => 10,  :default => 0.0,                   :null => false
    t.float     "discount",          :limit => 3,   :default => 0.0,                   :null => false
    t.integer   "apply_type",                       :default => 0,                     :null => false
    t.integer   "apply_point",                      :default => 0,                     :null => false
    t.integer   "apply_money",                      :default => 0,                     :null => false
    t.datetime  "apply_start_time",                 :default => '2013-01-01 00:00:00', :null => false
    t.datetime  "apply_end_time",                   :default => '2013-01-01 00:00:00', :null => false
    t.datetime  "start_time",                       :default => '2013-01-01 00:00:00', :null => false
    t.datetime  "end_time",                         :default => '2013-01-01 00:00:00'
    t.integer   "member_limit",                     :default => 0,                     :null => false
    t.integer   "personal_limit",                   :default => 0,                     :null => false
    t.integer   "current_count",                    :default => 0,                     :null => false
    t.string    "address",           :limit => 300, :default => "",                    :null => false
    t.string    "longitude",         :limit => 20,  :default => "",                    :null => false
    t.string    "latitude",          :limit => 20,  :default => "",                    :null => false
    t.text      "my_all_apply_code"
    t.datetime  "created_at",                       :default => '2000-01-01 00:00:00', :null => false
    t.timestamp "updated_at",                                                          :null => false
  end

  add_index "cms_info_coupons", ["cms_content_id"], :name => "cms_content_id"

  create_table "cms_info_customers", :force => true do |t|
    t.integer   "user_info_id",                 :default => 0,                     :null => false
    t.integer   "cms_content_id",               :default => 0,                     :null => false
    t.string    "name",           :limit => 50, :default => "",                    :null => false
    t.string    "nickname",       :limit => 50, :default => "",                    :null => false
    t.string    "cardnum",        :limit => 50, :default => "",                    :null => false
    t.datetime  "birthday",                     :default => '1991-01-01 00:00:00', :null => false
    t.integer   "sex",                          :default => 1,                     :null => false
    t.string    "picture",        :limit => 50, :default => "",                    :null => false
    t.string    "phonenumber",    :limit => 50, :default => "",                    :null => false
    t.string    "email",          :limit => 50, :default => "",                    :null => false
    t.string    "qq",             :limit => 50, :default => "",                    :null => false
    t.text      "detail",                                                          :null => false
    t.integer   "product_num",                  :default => 0,                     :null => false
    t.integer   "product_use",                  :default => 0,                     :null => false
    t.datetime  "created_at",                   :default => '2000-01-01 00:00:00', :null => false
    t.timestamp "updated_at",                                                      :null => false
  end

  create_table "cms_info_groupons", :force => true do |t|
    t.integer   "cms_content_id"
    t.boolean   "is_effective",                    :default => true,                  :null => false
    t.integer   "cms_info_shop_id",                :default => 0,                     :null => false
    t.float     "price",            :limit => 10,  :default => 0.0,                   :null => false
    t.float     "price_old",        :limit => 10,  :default => 0.0,                   :null => false
    t.float     "discount",         :limit => 3,   :default => 0.0,                   :null => false
    t.integer   "apply_type",                      :default => 0,                     :null => false
    t.integer   "apply_point",                     :default => 0,                     :null => false
    t.integer   "apply_money",                     :default => 0,                     :null => false
    t.datetime  "apply_start_time",                :default => '2000-01-01 00:00:00', :null => false
    t.datetime  "apply_end_time",                  :default => '2000-01-01 00:00:00', :null => false
    t.datetime  "start_time",                      :default => '2000-01-01 00:00:00', :null => false
    t.datetime  "end_time",                        :default => '2000-01-01 00:00:00', :null => false
    t.integer   "member_limit",                    :default => 0,                     :null => false
    t.integer   "personal_limit",                  :default => 0
    t.integer   "current_count",                   :default => 0
    t.string    "address",          :limit => 300, :default => "",                    :null => false
    t.string    "longitude",        :limit => 20,  :default => "",                    :null => false
    t.string    "latitude",         :limit => 20,  :default => ""
    t.datetime  "created_at",                      :default => '2000-01-01 00:00:00', :null => false
    t.timestamp "updated_at",                                                         :null => false
  end

  create_table "cms_info_limitcoupons", :force => true do |t|
    t.integer   "cms_content_id"
    t.boolean   "is_effective",                     :default => true,                  :null => false
    t.integer   "cms_info_shop_id",                 :default => 0,                     :null => false
    t.float     "price",             :limit => 10,  :default => 0.0,                   :null => false
    t.float     "price_old",         :limit => 10,  :default => 0.0,                   :null => false
    t.float     "discount",          :limit => 3,   :default => 0.0,                   :null => false
    t.integer   "apply_type",                       :default => 0,                     :null => false
    t.integer   "apply_point",                      :default => 0,                     :null => false
    t.integer   "apply_money",                      :default => 0,                     :null => false
    t.datetime  "apply_start_time",                 :default => '2000-01-01 00:00:00', :null => false
    t.datetime  "apply_end_time",                   :default => '2000-01-01 00:00:00', :null => false
    t.datetime  "start_time",                       :default => '2000-01-01 00:00:00', :null => false
    t.datetime  "end_time",                         :default => '2000-01-01 00:00:00', :null => false
    t.integer   "member_limit",                     :default => 0,                     :null => false
    t.integer   "personal_limit",                   :default => 0,                     :null => false
    t.integer   "current_count",                    :default => 0,                     :null => false
    t.string    "address",           :limit => 300, :default => "",                    :null => false
    t.string    "longitude",         :limit => 20,  :default => "",                    :null => false
    t.string    "latitude",          :limit => 20,  :default => "",                    :null => false
    t.text      "my_all_apply_code",                                                   :null => false
    t.datetime  "created_at",                       :default => '2000-01-01 00:00:00', :null => false
    t.timestamp "updated_at",                                                          :null => false
  end

  create_table "cms_info_news", :force => true do |t|
    t.integer "cms_content_id", :null => false
  end

  create_table "cms_info_plans", :force => true do |t|
    t.string    "start_time",           :limit => 50,  :default => "2000-01-01 00:00:00", :null => false
    t.string    "end_time",             :limit => 50,  :default => "2000-01-01 00:00:00", :null => false
    t.datetime  "date_ymd",                            :default => '2000-01-01 00:00:00', :null => false
    t.string    "summary",              :limit => 100, :default => "",                    :null => false
    t.integer   "cms_content_id",                      :default => 0,                     :null => false
    t.integer   "cms_info_customer_id",                :default => 0,                     :null => false
    t.integer   "act_task_id",                         :default => 0,                     :null => false
    t.integer   "act_statu_id",                        :default => 0,                     :null => false
    t.datetime  "created_at",                          :default => '2000-01-01 00:00:00', :null => false
    t.timestamp "updated_at",                                                             :null => false
  end

  create_table "cms_info_product_prices", :force => true do |t|
    t.integer  "cms_content_id",                                             :default => 0,                     :null => false
    t.date     "that_date"
    t.integer  "level",                                                      :default => 0,                     :null => false
    t.integer  "week_day",       :limit => 2
    t.datetime "start_time",                                                 :default => '2000-01-01 00:00:00', :null => false
    t.datetime "end_time",                                                   :default => '2100-01-01 00:00:00', :null => false
    t.decimal  "price",                       :precision => 10, :scale => 2, :default => 0.0,                   :null => false
    t.integer  "num",                                                        :default => 1,                     :null => false
    t.integer  "p_0",                                                        :default => 0,                     :null => false
    t.integer  "p_1",                                                        :default => 0,                     :null => false
    t.integer  "p_2",                                                        :default => 0,                     :null => false
    t.integer  "p_3",                                                        :default => 0,                     :null => false
    t.integer  "p_4",                                                        :default => 0,                     :null => false
  end

  create_table "cms_info_product_prices_cms_sort_types", :id => false, :force => true do |t|
    t.integer "cms_info_product_price_id"
    t.integer "cms_sort_type_id"
  end

  create_table "cms_info_products", :force => true do |t|
    t.integer   "cms_content_id",                 :default => 0,                     :null => false
    t.boolean   "is_effective",                   :default => true
    t.boolean   "is_buy",                         :default => false
    t.boolean   "is_order",                       :default => false
    t.boolean   "is_pay",                         :default => false
    t.integer   "cms_info_shop_id",               :default => 0
    t.float     "price",            :limit => 10, :default => 0.0
    t.float     "price_old",        :limit => 10, :default => 0.0
    t.float     "discount",         :limit => 3,  :default => 0.0
    t.integer   "apply_type",                     :default => 0
    t.integer   "apply_point",                    :default => 0
    t.integer   "apply_money",                    :default => 0
    t.datetime  "apply_start_time",               :default => '2000-01-01 00:00:00'
    t.datetime  "apply_end_time",                 :default => '2000-01-01 00:00:00'
    t.datetime  "start_time",                     :default => '2000-01-01 00:00:00'
    t.datetime  "end_time",                       :default => '2100-01-01 00:00:00'
    t.integer   "member_limit",                   :default => 0
    t.integer   "current_count",                  :default => 0
    t.integer   "order_count",                    :default => 0
    t.datetime  "created_at",                     :default => '2000-01-01 00:00:00', :null => false
    t.timestamp "updated_at",                                                        :null => false
  end

  add_index "cms_info_products", ["cms_content_id"], :name => "cms_content_id"

  create_table "cms_info_schedules", :force => true do |t|
    t.integer  "teacher_content_id",                :default => 0,                     :null => false
    t.integer  "shop_content_id",                   :default => 0,                     :null => false
    t.integer  "cms_content_id",                    :default => 0,                     :null => false
    t.integer  "project_info_id",                   :default => 0,                     :null => false
    t.integer  "course_content_id",                 :default => 0,                     :null => false
    t.integer  "week_day",                          :default => 1,                     :null => false
    t.datetime "date_ym",                           :default => '2000-01-01 00:00:00', :null => false
    t.string   "start_time",         :limit => 50,  :default => "0",                   :null => false
    t.string   "title",              :limit => 200, :default => "0",                   :null => false
    t.string   "picture",            :limit => 200, :default => "0",                   :null => false
    t.string   "duration",           :limit => 20,  :default => "0",                   :null => false
  end

  create_table "cms_info_sets", :force => true do |t|
    t.integer "content_count", :default => 0, :null => false
  end

  create_table "cms_info_shops", :force => true do |t|
    t.integer   "cms_content_id",                 :default => 0,                     :null => false
    t.integer   "member_num",                     :default => 0,                     :null => false
    t.string    "shop_num",        :limit => 100, :default => "0",                   :null => false
    t.string    "phone_num",       :limit => 50,  :default => "0",                   :null => false
    t.string    "address",         :limit => 300, :default => "",                    :null => false
    t.string    "longitude",       :limit => 20,  :default => "0",                   :null => false
    t.string    "latitude",        :limit => 20,  :default => "0",                   :null => false
    t.string    "gps_longitude",   :limit => 20,  :default => "",                    :null => false
    t.string    "gps_latitude",    :limit => 20,  :default => "",                    :null => false
    t.string    "baidu_longitude", :limit => 20,  :default => "",                    :null => false
    t.string    "baidu_latitude",  :limit => 20,  :default => "",                    :null => false
    t.datetime  "created_at",                     :default => '2000-01-01 00:00:00', :null => false
    t.timestamp "updated_at",                                                        :null => false
  end

  add_index "cms_info_shops", ["baidu_longitude", "baidu_latitude"], :name => "baidu_longitude"
  add_index "cms_info_shops", ["cms_content_id"], :name => "cms_content_id"

  create_table "cms_info_teachers", :force => true do |t|
    t.integer "cms_content_id",                :default => 0,  :null => false
    t.string  "name",           :limit => 50,  :default => "", :null => false
    t.string  "picture",        :limit => 100, :default => "", :null => false
    t.string  "sex",            :limit => 10,  :default => "", :null => false
    t.string  "nickname",       :limit => 50,  :default => "", :null => false
    t.string  "birthday",       :limit => 50,  :default => "", :null => false
    t.text    "detail",                                        :null => false
  end

  create_table "cms_sort_type_delegate", :force => true do |t|
    t.integer "cms_sort_type_id"
    t.text    "data"
    t.string  "fn",               :limit => 50
    t.string  "name",             :limit => 50
    t.string  "source_id",        :limit => 50
  end

  create_table "cms_sort_types", :force => true do |t|
    t.integer   "father_id",                  :default => 0
    t.string    "value",       :limit => 50
    t.string    "name",        :limit => 100, :default => "",                    :null => false
    t.string    "cnname",      :limit => 100, :default => "",                    :null => false
    t.integer   "sort_order",  :limit => 2,                                      :null => false
    t.text      "description",                                                   :null => false
    t.datetime  "created_at",                 :default => '2000-01-01 00:00:00', :null => false
    t.timestamp "updated_at",                                                    :null => false
    t.integer   "status",                                                        :null => false
  end

  create_table "cms_sorts", :force => true do |t|
    t.string    "type",             :limit => 50,  :default => ""
    t.string    "cnname",           :limit => 100
    t.integer   "project_info_id",                 :default => 0
    t.integer   "father_id",                       :default => 0
    t.integer   "lft",                             :default => 0
    t.integer   "rgt",                             :default => 0
    t.integer   "top_sort_id",                     :default => 0
    t.integer   "level",            :limit => 1,   :default => 0
    t.boolean   "is_property",                     :default => false
    t.integer   "sort_order",       :limit => 2,   :default => 0
    t.integer   "cms_sort_type_id",                :default => 0
    t.integer   "content_count",                   :default => 0
    t.integer   "order_limit",                     :default => 0
    t.integer   "order_now",                       :default => 0
    t.string    "name",             :limit => 100, :default => ""
    t.string    "sort_img",         :limit => 400, :default => ""
    t.text      "description"
    t.datetime  "created_at",                      :default => '2000-01-01 00:00:00'
    t.timestamp "updated_at"
  end

  add_index "cms_sorts", ["father_id"], :name => "father_id"
  add_index "cms_sorts", ["sort_order"], :name => "sort_order"
  add_index "cms_sorts", ["top_sort_id"], :name => "top_sort_id"

  create_table "cms_sorts_cms_sort_types", :id => false, :force => true do |t|
    t.integer "cms_sort_id"
    t.integer "cms_sort_type_id"
  end

  create_table "cms_sorts_plugincfg_infos", :id => false, :force => true do |t|
    t.integer "cms_sort_id",       :null => false
    t.integer "plugincfg_info_id", :null => false
  end

  create_table "coupon_contents_shop_contents", :id => false, :force => true do |t|
    t.integer "coupon_content_id", :null => false
    t.integer "shop_content_id",   :null => false
  end

  add_index "coupon_contents_shop_contents", ["shop_content_id"], :name => "shop_content_id"

  create_table "customer_bodysides", :force => true do |t|
    t.integer "cms_info_customer_id",               :default => 0,  :null => false
    t.integer "cms_content_id",                     :default => 0,  :null => false
    t.string  "picture",              :limit => 50, :default => "", :null => false
  end

  create_table "customer_trainingplans", :force => true do |t|
    t.integer "cms_info_customer_id",                :default => 0,   :null => false
    t.integer "cms_content_id",                      :default => 0,   :null => false
    t.string  "content",              :limit => 100, :default => "0", :null => false
  end

  create_table "dy_datasource", :primary_key => "DataSourceId", :force => true do |t|
    t.string "Name",          :limit => 50,   :default => ""
    t.string "DisplayName",   :limit => 50
    t.binary "AutoOptTable",  :limit => 1
    t.string "TableName",     :limit => 50
    t.string "Description",   :limit => 4000
    t.binary "AutoTreeTable", :limit => 1
    t.string "TreeTableId",   :limit => 50
    t.string "Version",       :limit => 20
  end

  create_table "dy_datasource_command", :primary_key => "CommandId", :force => true do |t|
    t.string "DataSourceName",       :limit => 50
    t.string "CommandName",          :limit => 50
    t.string "CommandDisplayName",   :limit => 50
    t.binary "IsRunEval",            :limit => 1
    t.text   "RunEvalTpl"
    t.binary "IsEvalSqlTpl",         :limit => 1
    t.text   "EvalSqlTpl"
    t.string "SqlResultType",        :limit => 50
    t.text   "DataMaps"
    t.binary "IsOutEval",            :limit => 1
    t.text   "OutEval"
    t.binary "IsOutProcessDelegate", :limit => 1
    t.string "OutProcessDelegate",   :limit => 80
    t.binary "IsOutProcessType",     :limit => 1
    t.string "OutProcessType",       :limit => 80
    t.string "DescInParams",         :limit => 1000
    t.string "DescData",             :limit => 2000
    t.string "DescOutFields",        :limit => 1000
    t.string "DescOther",            :limit => 1000
    t.string "Version",              :limit => 20
  end

  create_table "dy_web_api", :primary_key => "ApiId", :force => true do |t|
    t.string "ApiDisplayName",               :limit => 50
    t.string "ApiResource",                  :limit => 50
    t.string "ApiName",                      :limit => 50
    t.binary "IsHandlerType",                :limit => 1
    t.string "HandlerType",                  :limit => 100
    t.text   "HandlerParams"
    t.binary "IsHandlerDelegate",            :limit => 1
    t.string "HandlerDelegate",              :limit => 100
    t.text   "HandlerDelegateParams"
    t.text   "ConfigParams"
    t.string "DataSourceName",               :limit => 50
    t.string "Source",                       :limit => 50
    t.string "CommandName",                  :limit => 50
    t.string "CommandVersion",               :limit => 20
    t.string "ParamFromRequstSource",        :limit => 50
    t.string "ParamFromRequstName",          :limit => 50
    t.text   "InMaps"
    t.binary "IsParamsEval",                 :limit => 1
    t.text   "ParamsEval"
    t.binary "IsProcessDataEval",            :limit => 1
    t.text   "ProcessDataEval"
    t.string "ActionResultType",             :limit => 50
    t.binary "IsAuthorization",              :limit => 1
    t.binary "IsAuthenticationType",         :limit => 1
    t.string "AuthenticationType",           :limit => 80
    t.text   "AuthenticationTypeParams"
    t.binary "IsAuthenticationDelegate",     :limit => 1
    t.string "AuthenticationDelegate",       :limit => 80
    t.text   "AuthenticationDelegateParams"
    t.text   "Description"
    t.string "DescInParams",                 :limit => 1000
    t.string "DescOutExample",               :limit => 2000
    t.string "DescOutFields",                :limit => 1000
    t.text   "DescOutOther"
    t.string "DescRequstMethod",             :limit => 20
    t.string "DescAuthorize",                :limit => 100
    t.text   "DescErrors"
    t.string "DescOther",                    :limit => 1000
    t.binary "IsCache",                      :limit => 1
    t.string "CacheType",                    :limit => 80
    t.string "CacheId",                      :limit => 50
    t.string "CacheParams",                  :limit => 2000
    t.string "Version",                      :limit => 20
    t.binary "IsTrace",                      :limit => 1
    t.binary "IsDebug",                      :limit => 1
    t.text   "Channels"
  end

  create_table "dy_web_api_pushs", :force => true do |t|
    t.string  "web_api_id",            :limit => 50, :null => false
    t.integer "project_info_id",                     :null => false
    t.string  "to_source",             :limit => 50, :null => false
    t.text    "to_channels",                         :null => false
    t.text    "condition_expression",                :null => false
    t.string  "condition_fn",          :limit => 80, :null => false
    t.text    "condition_tpl_handler",               :null => false
    t.text    "config",                              :null => false
    t.binary  "enabled",               :limit => 1,  :null => false
  end

  create_table "form_infos", :force => true do |t|
    t.integer  "project_info_id"
    t.integer  "user_info_id"
    t.integer  "state"
    t.integer  "form_scheme_id"
    t.integer  "batch_id"
    t.text     "op1"
    t.text     "op2"
    t.text     "op3"
    t.text     "op4"
    t.text     "op5"
    t.text     "op6"
    t.text     "op7"
    t.text     "op8"
    t.text     "op9"
    t.text     "op10"
    t.text     "op11"
    t.text     "op12"
    t.text     "op13"
    t.text     "op14"
    t.text     "op15"
    t.text     "op16"
    t.text     "op17"
    t.text     "op18"
    t.text     "op19"
    t.text     "op20"
    t.text     "op21"
    t.text     "op22"
    t.text     "op23"
    t.text     "op24"
    t.text     "op25"
    t.text     "op26"
    t.text     "op27"
    t.text     "op28"
    t.text     "op29"
    t.text     "op30"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "form_infos", ["form_scheme_id", "batch_id"], :name => "scheme_batch"

  create_table "form_schemes", :force => true do |t|
    t.integer  "project_info_id"
    t.integer  "sort_id"
    t.integer  "state"
    t.integer  "form_num"
    t.string   "name"
    t.text     "description"
    t.text     "cols_order"
    t.string   "op1_name"
    t.text     "op1_config"
    t.string   "op2_name"
    t.text     "op2_config"
    t.string   "op3_name"
    t.text     "op3_config"
    t.string   "op4_name"
    t.text     "op4_config"
    t.string   "op5_name"
    t.text     "op5_config"
    t.string   "op6_name"
    t.text     "op6_config"
    t.string   "op7_name"
    t.text     "op7_config"
    t.string   "op8_name"
    t.text     "op8_config"
    t.string   "op9_name"
    t.text     "op9_config"
    t.string   "op10_name"
    t.text     "op10_config"
    t.string   "op11_name"
    t.text     "op11_config"
    t.string   "op12_name"
    t.text     "op12_config"
    t.string   "op13_name"
    t.text     "op13_config"
    t.string   "op14_name"
    t.text     "op14_config"
    t.string   "op15_name"
    t.text     "op15_config"
    t.string   "op16_name"
    t.text     "op16_config"
    t.string   "op17_name"
    t.text     "op17_config"
    t.string   "op18_name"
    t.text     "op18_config"
    t.string   "op19_name"
    t.text     "op19_config"
    t.string   "op20_name"
    t.text     "op20_config"
    t.string   "op21_name"
    t.text     "op21_config"
    t.string   "op22_name"
    t.text     "op22_config"
    t.string   "op23_name"
    t.text     "op23_config"
    t.string   "op24_name"
    t.text     "op24_config"
    t.string   "op25_name"
    t.text     "op25_config"
    t.string   "op26_name"
    t.text     "op26_config"
    t.string   "op27_name"
    t.text     "op27_config"
    t.string   "op28_name"
    t.text     "op28_config"
    t.string   "op29_name"
    t.text     "op29_config"
    t.string   "op30_name"
    t.text     "op30_config"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "job_config_sql_tpls", :force => true do |t|
    t.text   "text",                                          :null => false
    t.string "name",        :limit => 80,                     :null => false
    t.binary "enabled",     :limit => 1,  :default => "b'1'", :null => false
    t.string "action_name", :limit => 50,                     :null => false
  end

  create_table "job_configs", :force => true do |t|
    t.string   "name",               :limit => 80
    t.datetime "start_time"
    t.datetime "end_time"
    t.binary   "enabled",            :limit => 1
    t.integer  "time_type"
    t.string   "type_name",          :limit => 50
    t.text     "confgs"
    t.integer  "sort"
    t.string   "db_config_name",     :limit => 50
    t.string   "instance_type_name", :limit => 80
    t.binary   "select_tpl_enabled", :limit => 1
    t.binary   "insert_tpl_enabled", :limit => 1
    t.binary   "delete_tpl_enabled", :limit => 1
    t.integer  "select_sql_tpl_id"
    t.integer  "insert_sql_tpl_id"
    t.integer  "delete_sql_tpl_id"
    t.text     "report_keys"
  end

  create_table "job_exec_logs", :force => true do |t|
    t.datetime "job_time",      :null => false
    t.integer  "job_config_id", :null => false
    t.datetime "created_at",    :null => false
    t.integer  "status",        :null => false
    t.text     "trace"
    t.text     "result"
    t.float    "exec_seconds",  :null => false
  end

  create_table "message_contents", :force => true do |t|
    t.integer  "project_info_id",                                :null => false
    t.string   "room_name",       :limit => 23,  :default => "", :null => false
    t.boolean  "msg_type",                                       :null => false
    t.integer  "sender_id",                                      :null => false
    t.string   "sender_name",     :limit => 100,                 :null => false
    t.string   "sender_avatar",   :limit => 100,                 :null => false
    t.integer  "receiver_id"
    t.string   "receiver_name",   :limit => 100, :default => ""
    t.string   "image",           :limit => 100, :default => ""
    t.string   "sound",           :limit => 100, :default => ""
    t.text     "content"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
  end

  add_index "message_contents", ["room_name", "id"], :name => "room_id"

  create_table "news_contents_product_contents", :force => true do |t|
    t.integer "news_content_id",    :null => false
    t.integer "product_content_id", :null => false
  end

  create_table "news_contents_shop_contents", :id => false, :force => true do |t|
    t.integer "news_content_id", :null => false
    t.integer "shop_content_id", :null => false
  end

  add_index "news_contents_shop_contents", ["shop_content_id"], :name => "shop_content_id"

  create_table "news_contents_user_groups", :id => false, :force => true do |t|
    t.integer "user_group_id",   :null => false
    t.integer "news_content_id", :null => false
  end

  create_table "plugincfg_field_infos", :force => true do |t|
    t.integer  "plugincfg_info_id"
    t.integer  "plugincfg_field_id"
    t.string   "show_name"
    t.string   "value"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "plugincfg_fields", :force => true do |t|
    t.integer  "plugincfg_type_id"
    t.string   "name"
    t.string   "show_name"
    t.text     "description"
    t.string   "field_type"
    t.string   "field_options"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "plugincfg_infos", :force => true do |t|
    t.integer  "plugincfg_type_id"
    t.integer  "project_info_id"
    t.string   "name"
    t.string   "show_name"
    t.text     "configs"
    t.text     "description"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "plugincfg_open_apis", :force => true do |t|
    t.string    "name",         :limit => 50
    t.text      "configs"
    t.text      "in_json"
    t.text      "out_json"
    t.string    "official_url", :limit => 50
    t.text      "desc"
    t.datetime  "created_at"
    t.timestamp "update_at"
  end

  create_table "plugincfg_open_apis_project_infos", :force => true do |t|
    t.integer   "project_info_id",       :default => 0, :null => false
    t.integer   "plugincfg_open_api_id", :default => 0, :null => false
    t.text      "in_json"
    t.text      "configs"
    t.datetime  "created_at"
    t.timestamp "updated_at",                           :null => false
  end

  create_table "plugincfg_sorts", :force => true do |t|
    t.string   "name"
    t.string   "show_name"
    t.text     "description"
    t.datetime "created_at",  :default => '2000-01-01 00:00:00', :null => false
    t.datetime "updated_at",                                     :null => false
  end

  create_table "plugincfg_types", :force => true do |t|
    t.integer   "plugincfg_sort_id"
    t.string    "name"
    t.string    "show_name"
    t.text      "configs",                                              :null => false
    t.text      "description",                                          :null => false
    t.datetime  "created_at",        :default => '2000-01-01 00:00:00', :null => false
    t.timestamp "updated_at",                                           :null => false
  end

  create_table "point_access_rules", :force => true do |t|
    t.integer "project_info_id",      :default => 0, :null => false
    t.integer "point_action_type_id", :default => 0, :null => false
    t.integer "is_add",               :default => 0, :null => false
    t.integer "point_excute_rule_id", :default => 0, :null => false
  end

  create_table "point_action_types", :force => true do |t|
    t.string    "name",        :limit => 50, :default => "",                    :null => false
    t.string    "cnname",      :limit => 50, :default => "",                    :null => false
    t.text      "description",                                                  :null => false
    t.datetime  "created_at",                :default => '2000-01-01 00:00:00', :null => false
    t.timestamp "updated_at",                                                   :null => false
  end

  create_table "point_excute_rules", :force => true do |t|
    t.string  "cycle",       :limit => 50, :default => "", :null => false
    t.integer "point_count",               :default => 0,  :null => false
    t.string  "condition",                 :default => "", :null => false
  end

  create_table "point_logs", :force => true do |t|
    t.integer   "point_action_type_id",               :default => 0,     :null => false
    t.integer   "user_info_id",                       :default => 0,     :null => false
    t.integer   "project_info_id",                    :default => 0,     :null => false
    t.integer   "cms_content_id",                     :default => 0,     :null => false
    t.boolean   "is_add",                             :default => false, :null => false
    t.string    "description",          :limit => 20, :default => "",    :null => false
    t.timestamp "updated_at",                                            :null => false
  end

  create_table "product_contents_relproduct_contents", :id => false, :force => true do |t|
    t.integer "product_content_id",    :default => 0, :null => false
    t.integer "relproduct_content_id",                :null => false
  end

  create_table "product_contents_shop_contents", :id => false, :force => true do |t|
    t.integer "product_content_id", :default => 0, :null => false
    t.integer "shop_content_id",                   :null => false
  end

  add_index "product_contents_shop_contents", ["shop_content_id"], :name => "shop_content_id"

  create_table "project_app_down_logs", :force => true do |t|
    t.integer   "project_app_id", :default => 0, :null => false
    t.timestamp "updated_at",                    :null => false
  end

  create_table "project_app_state_logs", :force => true do |t|
    t.integer   "project_app_id"
    t.integer   "app_state",      :limit => 1
    t.text      "des"
    t.string    "attachment",     :limit => 200, :default => ""
    t.datetime  "log_time"
    t.timestamp "updated_at"
  end

  create_table "project_app_uploads", :force => true do |t|
    t.integer   "project_app_id",                                :null => false
    t.string    "file",           :limit => 200, :default => "", :null => false
    t.string    "version",        :limit => 30,  :default => "", :null => false
    t.text      "des",                                           :null => false
    t.string    "apptype",        :limit => 50,  :default => "", :null => false
    t.timestamp "updated_at",                                    :null => false
  end

  create_table "project_apps", :force => true do |t|
    t.integer   "project_info_id",                      :default => 0,                     :null => false
    t.string    "api_key",               :limit => 32,  :default => "",                    :null => false
    t.string    "api_secret",            :limit => 32,  :default => "",                    :null => false
    t.string    "app_client_num",        :limit => 32,  :default => ""
    t.integer   "app_state",             :limit => 1,   :default => 0,                     :null => false
    t.string    "phonetype",             :limit => 32,  :default => "",                    :null => false
    t.string    "name",                  :limit => 100, :default => "",                    :null => false
    t.string    "cnname",                :limit => 100, :default => "",                    :null => false
    t.string    "version_num",           :limit => 20,  :default => "",                    :null => false
    t.text      "slogan",                                                                  :null => false
    t.text      "description",                                                             :null => false
    t.text      "newupdate_description",                                                   :null => false
    t.text      "content",                                                                 :null => false
    t.string    "image_i1",              :limit => 200, :default => "",                    :null => false
    t.string    "image_i2",              :limit => 200, :default => "",                    :null => false
    t.string    "image_i3",              :limit => 200, :default => "",                    :null => false
    t.string    "image_i4",              :limit => 200, :default => "",                    :null => false
    t.string    "image_i5",              :limit => 200, :default => "",                    :null => false
    t.string    "image_icon",            :limit => 200, :default => "",                    :null => false
    t.integer   "download_count",                       :default => 0,                     :null => false
    t.string    "download_url",          :limit => 200, :default => "",                    :null => false
    t.integer   "active_count",                         :default => 0,                     :null => false
    t.integer   "push_count",                           :default => 0,                     :null => false
    t.datetime  "last_push_time",                       :default => '2000-01-01 00:00:00', :null => false
    t.integer   "mounth_push_count",                    :default => 0,                     :null => false
    t.string    "apn_sandbox_key"
    t.string    "apn_production_key"
    t.string    "weixin_secret_key"
    t.string    "weixin_token"
    t.string    "weixin_appid"
    t.string    "weixin_appsecret"
    t.datetime  "created_at",                           :default => '2000-01-01 00:00:00', :null => false
    t.timestamp "updated_at",                                                              :null => false
  end

  add_index "project_apps", ["weixin_secret_key"], :name => "weixin_secret_key"
  add_index "project_apps", ["weixin_token"], :name => "weixin_token"

  create_table "project_busi_types", :force => true do |t|
    t.string    "name",        :limit => 50,  :default => "",                    :null => false
    t.string    "cnname",      :limit => 200, :default => "",                    :null => false
    t.text      "description",                                                   :null => false
    t.datetime  "created_at",                 :default => '2000-01-01 00:00:00', :null => false
    t.timestamp "updated_at",                                                    :null => false
  end

  create_table "project_companies", :force => true do |t|
    t.string    "name",        :limit => 50,  :default => "",                    :null => false
    t.string    "address",     :limit => 250, :default => "",                    :null => false
    t.string    "phone",       :limit => 100, :default => "",                    :null => false
    t.text      "description",                                                   :null => false
    t.datetime  "created_at",                 :default => '2000-01-01 00:00:00', :null => false
    t.timestamp "updated_at",                                                    :null => false
  end

  create_table "project_ecard_sorts", :force => true do |t|
    t.integer   "project_info_id",                :default => 0,                     :null => false
    t.string    "name",            :limit => 50,  :default => "",                    :null => false
    t.string    "cnname",          :limit => 200, :default => "",                    :null => false
    t.text      "description",                                                       :null => false
    t.integer   "start_num",                      :default => 0,                     :null => false
    t.integer   "card_limit",                     :default => 0,                     :null => false
    t.integer   "card_digit",                     :default => 0,                     :null => false
    t.text      "num_rule",                                                          :null => false
    t.datetime  "created_at",                     :default => '2000-01-01 00:00:00', :null => false
    t.timestamp "updated_at",                                                        :null => false
  end

  create_table "project_infos", :force => true do |t|
    t.integer   "project_companie_id",                :default => 0,                     :null => false
    t.integer   "father_id",                          :default => 0,                     :null => false
    t.integer   "channel_id",                         :default => 0,                     :null => false
    t.text      "app_config",                                                            :null => false
    t.integer   "project_num",                        :default => 0,                     :null => false
    t.string    "project_logo",        :limit => 500, :default => "",                    :null => false
    t.string    "project_guide",       :limit => 500, :default => "",                    :null => false
    t.string    "name",                :limit => 50,  :default => "",                    :null => false
    t.string    "cnname",              :limit => 200, :default => "",                    :null => false
    t.text      "description",                                                           :null => false
    t.datetime  "created_at",                         :default => '2000-01-01 00:00:00', :null => false
    t.timestamp "updated_at",                                                            :null => false
  end

  create_table "project_pay_infos", :force => true do |t|
  end

  create_table "project_publish_logs", :force => true do |t|
    t.integer   "project_app_id",                 :default => 0,                     :null => false
    t.string    "name",             :limit => 50, :default => "",                    :null => false
    t.string    "version_num",      :limit => 50, :default => "",                    :null => false
    t.text      "update_descption",                                                  :null => false
    t.string    "download_url",     :limit => 50, :default => "",                    :null => false
    t.datetime  "created_at",                     :default => '2000-01-01 00:00:00', :null => false
    t.timestamp "updated_at",                                                        :null => false
  end

  create_table "project_share_infos", :force => true do |t|
  end

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "report_date_coupons", :force => true do |t|
    t.datetime  "old_time"
    t.integer   "project_info_id",                  :default => 0
    t.integer   "project_app_id",                   :default => 0
    t.integer   "cms_content_id",                   :default => 0
    t.string    "cms_content_title", :limit => 120, :default => ""
    t.integer   "report_value",      :limit => 8,   :default => 0
    t.integer   "time_type",                        :default => 0
    t.datetime  "created_at"
    t.timestamp "updated_at"
  end

  create_table "report_date_projects", :force => true do |t|
    t.datetime  "old_time"
    t.integer   "project_info_id",               :default => 0
    t.integer   "project_app_id",                :default => 0
    t.string    "report_key",      :limit => 80, :default => ""
    t.integer   "report_value",    :limit => 8,  :default => 0
    t.integer   "time_type",                     :default => 0
    t.datetime  "created_at"
    t.timestamp "updated_at"
  end

  add_index "report_date_projects", ["old_time", "time_type"], :name => "join"
  add_index "report_date_projects", ["project_info_id", "time_type"], :name => "time"

  create_table "report_date_users", :force => true do |t|
    t.datetime  "old_time"
    t.integer   "user_info_id",                  :default => 0
    t.integer   "user_device_id",                :default => 0
    t.integer   "project_info_id",               :default => 0
    t.integer   "project_app_id",                :default => 0
    t.string    "report_key",      :limit => 80, :default => ""
    t.integer   "report_value",    :limit => 8,  :default => 0
    t.integer   "time_type",                     :default => 0
    t.datetime  "created_at"
    t.timestamp "updated_at"
  end

  create_table "sys_api_call_logs", :force => true do |t|
    t.integer   "project_info_id",                 :default => 0,  :null => false
    t.integer   "project_app_id",                  :default => 0,  :null => false
    t.integer   "user_info_id",                    :default => 0,  :null => false
    t.string    "method",           :limit => 150, :default => "", :null => false
    t.string    "api_version",      :limit => 20,  :default => "", :null => false
    t.text      "error_num",                                       :null => false
    t.text      "params",                                          :null => false
    t.text      "error_msg"
    t.float     "exec_millisecond"
    t.text      "exec_result"
    t.text      "exec_trace"
    t.integer   "status"
    t.timestamp "updated_at",                                      :null => false
    t.string    "access_token",     :limit => 32,  :default => "", :null => false
    t.string    "ip_address",       :limit => 20,  :default => "", :null => false
  end

  add_index "sys_api_call_logs", ["project_app_id", "updated_at", "user_info_id"], :name => "project_app_updated_at"

  create_table "sys_calendar_days", :force => true do |t|
    t.integer "time_type",  :limit => 1
    t.date    "date_start"
    t.date    "date_end"
    t.integer "week_num",   :limit => 1
    t.integer "year_week",  :limit => 1
    t.integer "year_month", :limit => 1
  end

  add_index "sys_calendar_days", ["date_start", "date_end"], :name => "date_between", :unique => true

  create_table "sys_code_actions", :force => true do |t|
    t.string    "code",             :limit => 40,  :default => "",                    :null => false
    t.integer   "project_info_id",                 :default => 0
    t.boolean   "is_redirect",                     :default => false
    t.string    "url",              :limit => 200, :default => ""
    t.text      "data"
    t.integer   "cms_sort_type_id",                :default => 0
    t.integer   "batch_value",                     :default => 0
    t.string    "value",            :limit => 50,  :default => ""
    t.boolean   "enabled",                         :default => true
    t.datetime  "created_at",                      :default => '1991-01-01 00:00:00'
    t.timestamp "updated_at"
  end

  add_index "sys_code_actions", ["code"], :name => "code", :unique => true

  create_table "sys_codes", :force => true do |t|
    t.string  "description", :limit => 500
    t.binary  "is_error",    :limit => 1
    t.integer "code"
    t.string  "cn_name",     :limit => 50
    t.string  "en_name",     :limit => 50
    t.string  "display_msg", :limit => 100
    t.string  "client_mark", :limit => 100
  end

  add_index "sys_codes", ["code"], :name => "code", :unique => true

  create_table "sys_error_logs", :force => true do |t|
    t.integer   "project_info_id",               :default => 0,  :null => false
    t.integer   "project_app_id",                :default => 0,  :null => false
    t.integer   "error_num",                     :default => 0,  :null => false
    t.string    "method",          :limit => 50, :default => "", :null => false
    t.timestamp "updated_at",                                    :null => false
  end

  create_table "sys_location_infos", :force => true do |t|
    t.integer  "project_info_id",                                :null => false
    t.integer  "in_effect",                                      :null => false
    t.integer  "father_id",                                      :null => false
    t.integer  "code",                                           :null => false
    t.string   "location_type",   :limit => 200, :default => "", :null => false
    t.string   "name",            :limit => 200, :default => "", :null => false
    t.string   "cnname",          :limit => 200, :default => "", :null => false
    t.string   "group_name",      :limit => 200, :default => "", :null => false
    t.integer  "order_level",                                    :null => false
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
  end

  add_index "sys_location_infos", ["cnname"], :name => "cnname"
  add_index "sys_location_infos", ["code"], :name => "code"
  add_index "sys_location_infos", ["father_id"], :name => "father_id"
  add_index "sys_location_infos", ["group_name", "order_level"], :name => "group_name"
  add_index "sys_location_infos", ["name"], :name => "name"

  create_table "sys_push_logs", :force => true do |t|
    t.integer  "user_info_id",      :default => 0,                     :null => false
    t.integer  "cms_content_id",    :default => 0,                     :null => false
    t.integer  "project_info_id",   :default => 0,                     :null => false
    t.integer  "sys_push_order_id", :default => 0,                     :null => false
    t.datetime "datetime",          :default => '1991-01-01 00:00:00', :null => false
    t.integer  "ispush",            :default => 0,                     :null => false
    t.datetime "created_at",        :default => '1991-01-01 00:00:00', :null => false
    t.datetime "updated_at",        :default => '1991-01-01 00:00:00', :null => false
  end

  add_index "sys_push_logs", ["user_info_id", "cms_content_id"], :name => "user_info_id"

  create_table "sys_push_orders", :force => true do |t|
    t.integer  "cms_content_id",                   :default => 0,                     :null => false
    t.integer  "project_info_id",                  :default => 0,                     :null => false
    t.integer  "cms_sort_id",                      :default => 0,                     :null => false
    t.string   "cms_content_title", :limit => 500, :default => "",                    :null => false
    t.datetime "updatetime",                       :default => '1991-01-01 00:00:00', :null => false
    t.string   "pushtype",          :limit => 100, :default => "content",             :null => false
  end

  create_table "sys_push_types", :force => true do |t|
    t.string    "name",        :limit => 50,  :default => "",                    :null => false
    t.string    "cnname",      :limit => 200, :default => "",                    :null => false
    t.text      "description",                                                   :null => false
    t.datetime  "created_at",                 :default => '2000-01-01 00:00:00', :null => false
    t.timestamp "updated_at",                                                    :null => false
  end

  create_table "sys_pushs_orders", :force => true do |t|
    t.integer   "project_app_id",                 :default => 0,                     :null => false
    t.string    "name",             :limit => 50, :default => "",                    :null => false
    t.integer   "status",                         :default => 0,                     :null => false
    t.integer   "sys_push_type_id",               :default => 0,                     :null => false
    t.integer   "content_id",                     :default => 0,                     :null => false
    t.text      "contents",                                                          :null => false
    t.string    "channeltype",      :limit => 50, :default => "",                    :null => false
    t.string    "channel",          :limit => 50, :default => "",                    :null => false
    t.datetime  "created_at",                     :default => '2000-01-01 00:00:00', :null => false
    t.timestamp "updated_at",                                                        :null => false
  end

  create_table "sys_web_sessions", :force => true do |t|
  end

  create_table "user_card_infos", :force => true do |t|
    t.integer   "project_ecard_sort_id",                :default => 0,                     :null => false
    t.integer   "project_info_id",                      :default => 0,                     :null => false
    t.integer   "user_info_id",                         :default => 0,                     :null => false
    t.string    "card_number",           :limit => 50,  :default => "",                    :null => false
    t.string    "name",                  :limit => 50,  :default => "",                    :null => false
    t.string    "cnname",                :limit => 200, :default => "",                    :null => false
    t.text      "description",                                                             :null => false
    t.datetime  "created_at",                           :default => '2000-01-01 00:00:00', :null => false
    t.timestamp "updated_at",                                                              :null => false
  end

  create_table "user_consignees", :force => true do |t|
    t.integer  "user_info_id",                     :default => 0,     :null => false
    t.string   "consignee_name",    :limit => 50,  :default => "0",   :null => false
    t.string   "consignee_address", :limit => 500, :default => "0",   :null => false
    t.integer  "consignee_zip",                    :default => 0
    t.string   "phone",             :limit => 50,  :default => "0",   :null => false
    t.boolean  "is_default",                       :default => false
    t.text     "remarks"
    t.datetime "created_at"
  end

  add_index "user_consignees", ["user_info_id"], :name => "user_info_id"

  create_table "user_delivery_info", :force => true do |t|
  end

  create_table "user_devices", :force => true do |t|
    t.integer   "type",                       :default => 0,                     :null => false
    t.string    "device_num",  :limit => 200, :default => "",                    :null => false
    t.string    "moble_model", :limit => 100, :default => "",                    :null => false
    t.string    "os_version",  :limit => 100, :default => ""
    t.string    "os_type",     :limit => 100, :default => ""
    t.datetime  "created_at",                 :default => '2000-01-01 00:00:00', :null => false
    t.timestamp "updated_at",                                                    :null => false
  end

  create_table "user_devices_user_infos", :force => true do |t|
    t.integer "user_device_id",                :default => 0,  :null => false
    t.integer "user_info_id",                  :default => 0,  :null => false
    t.string  "os_version",     :limit => 600, :default => "", :null => false
    t.string  "os_type",        :limit => 600, :default => "", :null => false
  end

  create_table "user_favs", :force => true do |t|
    t.integer  "restrict_id", :null => false
    t.integer  "from_id"
    t.integer  "to_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_favs", ["from_id"], :name => "from"
  add_index "user_favs", ["restrict_id"], :name => "restrict_id"
  add_index "user_favs", ["to_id"], :name => "to"

  create_table "user_groups", :force => true do |t|
    t.integer   "project_info_id",                                                   :null => false
    t.integer   "order_level",                    :default => 0
    t.string    "name",            :limit => 50,  :default => "",                    :null => false
    t.string    "cnname",          :limit => 200, :default => "",                    :null => false
    t.text      "subtitle",                                                          :null => false
    t.text      "description",                                                       :null => false
    t.string    "image_cover",     :limit => 200, :default => "",                    :null => false
    t.integer   "max_num",                        :default => 0,                     :null => false
    t.integer   "now_num",                        :default => 0
    t.integer   "news_num",                       :default => 0
    t.datetime  "created_at",                     :default => '2000-01-01 00:00:00', :null => false
    t.timestamp "updated_at",                                                        :null => false
  end

  create_table "user_groups_user_infos", :id => false, :force => true do |t|
    t.integer "user_info_id",  :null => false
    t.integer "user_group_id", :null => false
  end

  create_table "user_infos", :force => true do |t|
    t.integer   "project_info_id",                   :default => 0,                     :null => false
    t.integer   "user_group_id",                     :default => 0,                     :null => false
    t.integer   "user_role_id",                      :default => 0,                     :null => false
    t.integer   "vip_group",                         :default => 0,                     :null => false
    t.datetime  "vip_endtime",                       :default => '1991-01-01 00:00:00', :null => false
    t.string    "email",              :limit => 100, :default => "",                    :null => false
    t.string    "phone_number",       :limit => 100, :default => "",                    :null => false
    t.string    "password",           :limit => 32,  :default => "",                    :null => false
    t.string    "name",               :limit => 200, :default => "",                    :null => false
    t.string    "avatar",             :limit => 200, :default => ""
    t.string    "nickname",           :limit => 200, :default => ""
    t.text      "description"
    t.datetime  "birthday",                          :default => '1991-01-01 00:00:00'
    t.integer   "height",                            :default => 0
    t.integer   "weight",                            :default => 0
    t.string    "cnname",             :limit => 50,  :default => "0"
    t.integer   "sex",                               :default => -1
    t.integer   "admingroup",                        :default => 0
    t.integer   "integral",                          :default => 0
    t.string    "push_apn_token",                    :default => ""
    t.string    "push_android_token",                :default => ""
    t.datetime  "created_at",                        :default => '2000-01-01 00:00:00', :null => false
    t.timestamp "updated_at",                                                           :null => false
  end

  add_index "user_infos", ["phone_number"], :name => "phone_number"
  add_index "user_infos", ["project_info_id", "push_apn_token"], :name => "project_apnuser"
  add_index "user_infos", ["push_android_token"], :name => "push_android_token"

  create_table "user_oauth_token_orders", :force => true do |t|
    t.integer   "user_info_id",                  :default => 0,                     :null => false
    t.integer   "project_app_id",                :default => 0,                     :null => false
    t.integer   "user_device_id",                :default => 0,                     :null => false
    t.string    "access_token",   :limit => 32,  :default => "",                    :null => false
    t.integer   "expiresin",                     :default => 0,                     :null => false
    t.string    "refrechtoken",   :limit => 600, :default => "",                    :null => false
    t.string    "scope",          :limit => 600, :default => "",                    :null => false
    t.string    "os_version",     :limit => 600, :default => "",                    :null => false
    t.string    "os_type",        :limit => 600, :default => "",                    :null => false
    t.datetime  "created_at",                    :default => '2000-01-01 00:00:00', :null => false
    t.timestamp "updated_at",                                                       :null => false
  end

  add_index "user_oauth_token_orders", ["access_token"], :name => "access_token"
  add_index "user_oauth_token_orders", ["project_app_id"], :name => "project_app_id"
  add_index "user_oauth_token_orders", ["user_info_id"], :name => "user_info_id"

  create_table "user_recharge_logs", :force => true do |t|
  end

  create_table "user_recharge_orders", :force => true do |t|
  end

  create_table "user_roles", :force => true do |t|
    t.string    "name",        :limit => 50,  :default => "",                    :null => false
    t.string    "cnname",      :limit => 200, :default => "",                    :null => false
    t.text      "description",                                                   :null => false
    t.datetime  "created_at",                 :default => '2000-01-01 00:00:00', :null => false
    t.timestamp "updated_at",                                                    :null => false
  end

  create_table "user_signup_infos", :force => true do |t|
    t.integer  "user_info_id",                :default => 0,  :null => false
    t.string   "username",     :limit => 50,  :default => "", :null => false
    t.integer  "gender",       :limit => 1,   :default => 1
    t.integer  "age",                         :default => 0
    t.string   "phone",        :limit => 50,  :default => "", :null => false
    t.string   "address",      :limit => 250, :default => ""
    t.text     "remarks"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_sort_infos", :force => true do |t|
    t.integer "user_info_id",                     :default => 0, :null => false
    t.integer "project_info_id",                  :default => 0
    t.integer "valid_status",                     :default => 0
    t.integer "user_sort_type_id",                :default => 0, :null => false
    t.string  "char_value_0",      :limit => 50
    t.string  "char_value_1",      :limit => 50
    t.string  "char_value_2",      :limit => 50
    t.string  "char_value_3",      :limit => 50
    t.string  "char_value_4",      :limit => 50
    t.string  "img_0",             :limit => 100
    t.string  "img_1",             :limit => 100
    t.string  "img_2",             :limit => 100
    t.string  "img_3",             :limit => 100
    t.string  "img_4",             :limit => 100
  end

  add_index "user_sort_infos", ["project_info_id", "char_value_0"], :name => "project_info_id", :unique => true

  create_table "user_sort_types", :force => true do |t|
    t.integer   "father_id",                  :default => 0
    t.string    "cnname",      :limit => 50
    t.string    "name",        :limit => 50
    t.text      "info_desc"
    t.integer   "sort_order"
    t.string    "description", :limit => 100
    t.datetime  "created_at"
    t.timestamp "updated_at"
  end

  create_table "user_to_role", :force => true do |t|
    t.integer  "userid",     :default => 0,                     :null => false
    t.integer  "roleid",     :default => 0,                     :null => false
    t.integer  "createid",   :default => 0,                     :null => false
    t.datetime "createdate", :default => '1991-01-01 00:00:00', :null => false
  end

  create_table "user_vcode_orders", :force => true do |t|
    t.string   "mobile",     :limit => 11,                    :null => false
    t.string   "code",       :limit => 10, :default => "",    :null => false
    t.boolean  "isuse",                    :default => false, :null => false
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  add_index "user_vcode_orders", ["mobile", "code"], :name => "mobile"
  add_index "user_vcode_orders", ["updated_at"], :name => "updated_at"

  create_table "users_infos", :primary_key => "userid", :force => true do |t|
    t.string   "username",          :limit => 250, :default => "",                    :null => false
    t.string   "password",          :limit => 250, :default => "",                    :null => false
    t.integer  "projectid",                        :default => 0,                     :null => false
    t.string   "phonenumber",       :limit => 250, :default => "",                    :null => false
    t.string   "email",             :limit => 250, :default => "",                    :null => false
    t.datetime "updatetime",                       :default => '1991-01-01 00:00:00', :null => false
    t.string   "nickname",          :limit => 250, :default => "",                    :null => false
    t.integer  "qareplynum",                       :default => 0,                     :null => false
    t.integer  "feedbackreplaynum",                :default => 0,                     :null => false
    t.integer  "messagenum",                       :default => 0,                     :null => false
    t.datetime "birthday",                         :default => '1991-01-01 00:00:00', :null => false
    t.integer  "height",                           :default => 0,                     :null => false
    t.integer  "weight",                           :default => 0,                     :null => false
    t.string   "cnname",            :limit => 50,  :default => "0",                   :null => false
    t.integer  "sex",                              :default => 1,                     :null => false
    t.integer  "admingroup",                       :default => 0,                     :null => false
    t.integer  "integral",                         :default => 0,                     :null => false
  end

end
