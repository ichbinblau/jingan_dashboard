class Kf::CourseItemType < ActiveRecord::Base
	mount_uploader :image_cover, UserImagesUploader
	has_many :kf_course_index , class_name: "Kf::CourseIndex", foreign_key: "kf_course_item_type_id"
	attr_accessible :description, :image_cover, :order_level, :title
end
