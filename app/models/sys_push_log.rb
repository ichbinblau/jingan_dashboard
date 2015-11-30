# encoding: utf-8
class SysPushLog < ActiveRecord::Base
  attr_accessible  :cms_content_id,:project_info_id,:user_info_id
  belongs_to :cms_content
  belongs_to :project_info
  belongs_to :user_info
  rails_admin do
    visible false
  end
end