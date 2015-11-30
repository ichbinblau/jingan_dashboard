class ActSignupOrder < ActiveRecord::Migration
  def up
     create_table "act_signup_orders", :force => true do |t|
        t.integer  "project_info_id",                    :default => 0,                     :null => false
        t.integer  "user_info_id",                       :default => 0,                     :null => false
        t.integer  "cms_content_id",                     :default => 0,                     :null => false
        t.string   "title",               :limit => 500
        t.integer  "user_signup_id",                  :default => 0,                     :null => false
        t.text     "remarks"
        t.datetime "created_at"
        t.datetime "updated_at"
      end
  end

  def down
     drop_table "act_signup_orders"
  end
end
