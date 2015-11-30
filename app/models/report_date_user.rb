# encoding: utf-8
class ReportDateUser < ActiveRecord::Base
  attr_accessible :old_time , :project_info_id , :project_app_id , :cms_content_id ,:cms_content_title ,:report_key,:report_value ,:time_type
  rails_admin do
    visible false
  end
end
