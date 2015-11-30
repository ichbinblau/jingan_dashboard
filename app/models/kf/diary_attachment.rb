class Kf::DiaryAttachment < ActiveRecord::Base
	mount_uploader :attachment, UserImagesUploader

	belongs_to :kf_diary , class_name: "Kf::Diary"
	attr_accessible :attachment, :attachment_cache, :remove_attachment
	
	attr_accessible :attachment_type, :kf_diary_id, :order_level, :title
end
