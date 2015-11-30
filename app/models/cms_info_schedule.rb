class CmsInfoSchedule < ActiveRecord::Base
	# belongs_to :schedule_content,:inverse_of => :cms_info_schedule
	# belongs_to :shop_content,:inverse_of => :cms_info_shop
	# has_one :CmsContent 
	# belongs_to :shop_content 

	  attr_accessible  :cms_info_shop_id,:cms_info_teacher_id,:cms_info_course_id,:week_day ,:date_ym , :start_time,:title,:picture,:duration,:project_info_id #, :level , :top_sort_id

	  belongs_to :shop_content, :inverse_of => :cms_info_schedules
  	attr_accessible :shop_content_id
  	# attr_accessible :shop_content_attributes
  	# accepts_nested_attributes_for :shop_content, :allow_destroy => true
  	belongs_to :teacher_content, :inverse_of => :cms_info_schedules
  	attr_accessible :teacher_content_id

  	belongs_to :course_content, :inverse_of => :cms_info_schedules
  	attr_accessible :course_content_id

    belongs_to :project_info
    rails_admin do
		  visible false
    end
end