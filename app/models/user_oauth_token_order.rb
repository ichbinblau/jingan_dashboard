class UserOauthTokenOrder < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :user_info_id, :project_app_id, :user_device_id, :access_token, :expiresin, :created_at

  rails_admin do
    visible false
  end
end
