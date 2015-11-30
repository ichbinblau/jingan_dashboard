class ApiWebInfoTrigger < ActiveRecord::Base
  belongs_to :api_web_info
  attr_accessible :name , :description,   :project_info_id , :api_version_reg ,:api_web_info_id , :send_config , :call_url , :condition_exp ,:call_before_eval , :call_params , :enabled
  rails_admin do
    visible false
  end
end
