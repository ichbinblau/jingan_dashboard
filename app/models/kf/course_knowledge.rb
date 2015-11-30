class Kf::CourseKnowledge < ActiveRecord::Base
	mount_uploader :image_cover, UserImagesUploader

	belongs_to :kf_course_index , class_name: "Kf::CourseIndex" , foreign_key: "kf_course_index_id"
	has_many :course_knowledge_attachment , class_name: "Kf::CourseKnowledgeAttachment" , foreign_key: "kf_course_knowledge_id" , :order => "order_level desc"
	accepts_nested_attributes_for :course_knowledge_attachment, :allow_destroy => true
	attr_accessible :image_cover, :image_cover_cache, :remove_image_cover

	attr_accessible :course_knowledge_attachment_attributes , :course_knowledge_attachment_ids
	attr_accessible :code ,:content, :kf_course_id, :kf_course_index_id, :title, :description ,:order_level

	def clone_data( course_index_id )
		new_data = {
			:kf_course_index_id => course_index_id,
			:content => self.content,
			:description => self.description,
			:order_level => self.order_level,
			:title => self.title,
		}
		item = Kf::CourseKnowledge.new new_data
		item.image_cover.upload_url = self[:image_cover]
		item.save
		# 复制attachment
		self.course_knowledge_attachment.each do |index|
			index.clone_data(item.id)
		end
		return item
	end

	before_validation :ensure_code
	protected
	def ensure_code
		if self.code.nil? || self.code == 0
			self.code = rand(100000000..999999999)
			self.code = rand(1000000000..3999999998) unless Kf::Sort.where(:code => self.code).blank?
		end
	end
end
