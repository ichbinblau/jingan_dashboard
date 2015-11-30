class Kf::CourseIndexAttachment < ActiveRecord::Base
	mount_uploader :attachment, UserImagesUploader

	belongs_to :kf_course_index , class_name: "Kf::CourseIndex"
	attr_accessible :attachment, :attachment_cache, :remove_attachment
	attr_accessible :attachment_type, :kf_course_index_id, :order_level, :title

	def clone_data( course_index_id )
		new_data = {
			:attachment_type => self.attachment_type,
			:kf_course_index_id => course_index_id,
			:order_level => self.order_level,
			:title => self.title,
		}
		item = Kf::CourseIndexAttachment.new new_data
		item.attachment.upload_url = self[:attachment]
		item.save
		return item
	end
end
