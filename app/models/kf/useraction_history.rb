class Kf::UseractionHistory < ActiveRecord::Base
	belongs_to :kf_sort_type , class_name: "Kf::UseractionHistoryType" , foreign_key: "action_type"
	attr_accessible :action, :action_type , :kf_course_user_fav_id, :kf_course_id \
				, :kf_course_index_id, :kf_course_item_type_id, :user_info_id
end
