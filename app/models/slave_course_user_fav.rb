# encoding: utf-8
class SlaveCourseUserFav < SlaveModel
	self.table_name = "kf_course_user_favs"
	belongs_to :slave_user , class_name: "SlaveUserInfo" , foreign_key: "user_info_id"
	attr_accessible :day_1_time, :day_2_time, :day_3_time, :day_4_time, :day_5_time, :end_time, :kf_course_id, :start_time, :state, :user_info_id
end