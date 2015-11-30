class Kf::UseractionHistoryType < ActiveRecord::Base
	mount_uploader :image_cover, UserImagesUploader
	has_many :kf_course_index , class_name: "Kf::UseractionHistory", foreign_key: "action_type"
	attr_accessible :description, :image_cover, :order_level, :title
end
