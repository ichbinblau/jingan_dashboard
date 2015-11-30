class ApiWebInfo < ActiveRecord::Base
  attr_accessible :description, :project_info_id , :uri_resource, :is_deprecated, :is_authorization
  has_many :api_web_info_versions
  has_many :api_web_info_triggers
  rails_admin do
    visible false
  end
end
