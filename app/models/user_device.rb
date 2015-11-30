class UserDevice < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :type, :device_num, :moble_model, :created_at, :os_type, :os_version
  self.inheritance_column = nil

  rails_admin do
    visible false

  end
end
