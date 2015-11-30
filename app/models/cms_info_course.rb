# encoding: utf-8
class CmsInfoCourse < ActiveRecord::Base
	# belongs_to :cms_info_teacher,:inverse_of => :cms_info_teacher


	# belongs_to :course_content,:inverse_of => :cms_info_course
	# attr_accessible :description

	
	# # 课程与cms_content的关联
	# belongs_to :cms_content, :inverse_of => :cms_info_course
    # attr_accessible :cms_content_id

  	

    rails_admin do
		visible false
    end
end


