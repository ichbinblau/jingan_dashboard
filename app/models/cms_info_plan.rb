class CmsInfoPlan < ActiveRecord::Base
	attr_accessible :start_time,:end_time,:date_ymd,:summary,:cms_info_customer_id,:act_task_id,:act_statu_id
	belongs_to :cms_info_customer, :inverse_of => :cms_info_plans
    attr_accessible :cms_info_customer_id
    belongs_to :plan_content,:inverse_of => :cms_info_plans
    attr_accessible :plan_content_id

    belongs_to :act_statu, :inverse_of => :cms_info_plans
    attr_accessible :act_statu_id

    belongs_to :act_task, :inverse_of => :cms_info_plans
    attr_accessible :act_task_id

    rails_admin do
		  visible false
    end
end