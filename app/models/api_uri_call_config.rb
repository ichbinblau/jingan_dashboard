class ApiUriCallConfig < ActiveRecord::Base

  attr_accessible :id,:name , :description, :uri, :project_info_id , :api_call_uri_sort_id , :configs , :send_config ,:created_at,:updated_at, :enabled
  rails_admin do
    visible false
  end

end
