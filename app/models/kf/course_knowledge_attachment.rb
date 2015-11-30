class Kf::CourseKnowledgeAttachment < ActiveRecord::Base
	mount_uploader :attachment, UserImagesUploader

	belongs_to :kf_course_knowledge , class_name: "Kf::CourseKnowledge"
	attr_accessible :attachment, :attachment_cache, :remove_attachment
	
	attr_accessible :attachment_type, :kf_course_knowledge_id, :order_level, :title

	def clone_data( course_knowledge_id )
		new_data = {
			:attachment_type => self.attachment_type,
			:kf_course_knowledge_id => course_knowledge_id,
			:order_level => self.order_level,
			:title => self.title,
		}
		item = Kf::CourseKnowledgeAttachment.new new_data
		item.attachment.upload_url = self[:attachment]
		item.save
		return item
	end
end
