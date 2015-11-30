class UserSignupInfo < ActiveRecord::Migration
  def up
    create_table "user_signup_infos", :force => true do |t|
      t.integer  "user_info_id",                       :default => 0,                     :null => false
      t.string   "username",            :limit => 50,  :default => "",                    :null => false
      t.integer  "gender",                 :limit => 1,   :default => 1
      t.integer  "age",                                :default => 0
      t.string   "phone",               :limit => 50,  :default => "",                    :null => false
      t.string   "address",             :limit => 250, :default => ""
      t.text     "remarks"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end

  def down
      drop_table "user_signup_infos"
  end
end
