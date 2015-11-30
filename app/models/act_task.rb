class ActTask < ActiveRecord::Base
	# belongs_to :schedule_content,:inverse_of => :cms_info_schedule
	# belongs_to :shop_content,:inverse_of => :cms_info_shop
	# has_one :CmsContent 
	# belongs_to :shop_content 
    belongs_to :project_info
    belongs_to :user_info
	  attr_accessible  :user_info_id

    has_many :cms_info_plans, :inverse_of => :act_task
    attr_accessible :act_task_id,:name
	
  	# belongs_to :statu_content,:inverse_of => :act_statu 
  	# belongs_to :course_content, :inverse_of => :cms_info_schedules
  	# attr_accessible :course_content_id

    rails_admin do
      visible false
    end
end