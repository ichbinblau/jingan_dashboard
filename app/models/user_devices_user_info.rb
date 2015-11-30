class UserDevicesUserInfo < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :user_device_id, :user_info_id

  rails_admin do
    visible false
  end
end
