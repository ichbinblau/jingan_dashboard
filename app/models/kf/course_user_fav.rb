class Kf::CourseUserFav < ActiveRecord::Base
	belongs_to :user_info
	belongs_to :kf_course , class_name: "Kf::Course" , foreign_key: "kf_course_id"
	has_and_belongs_to_many :kf_diary , class_name: "Kf::Diary" , foreign_key: "kf_course_user_fav_id" \
							, association_foreign_key: "kf_diary_id"  , join_table: "kf_course_user_favs_kf_diaries"
	accepts_nested_attributes_for :kf_diary

	attr_accessible :kf_diary_attributes , :kf_diary_ids
	attr_accessible :day_1_time, :day_2_time, :day_3_time, :day_4_time, :day_5_time, :end_time, :kf_course_id, :start_time, :state, :user_info_id
end
