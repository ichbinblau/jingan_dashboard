class SysCodeAction < ActiveRecord::Base
  attr_accessible  :id , :code , :is_redirect , :url , :data , :batch_value , :value , :enabled ,:project_info_id
  rails_admin do
    visible false
  end
end