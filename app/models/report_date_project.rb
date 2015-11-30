# encoding: utf-8
class ReportDateProject < ActiveRecord::Base
  attr_accessible :old_time , :project_info_id , :project_app_id  ,:report_key  ,:report_value ,:time_type
  rails_admin do
    visible false
  end
end
