class Kf::UserNotice < ActiveRecord::Base
	attr_accessible :action, :day_start, :day_start_type, :kf_course_id, :kf_course_index_id, :notice_date, :title
end
