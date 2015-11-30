class Kf::CourseForm < ActiveRecord::Base
	mount_uploader :image_cover, UserImagesUploader

	belongs_to :kf_course_index , class_name: "Kf::CourseIndex" , foreign_key: "kf_course_index_id"
	attr_accessible :image_cover, :image_cover_cache, :remove_image_cover
	
	attr_accessible :code, :answer, :content, :description, :form_type, :kf_course_id, :kf_course_index_id, :order_level, :title 

	def clone_data( course_index_id )
		new_data = {
			:kf_course_index_id => course_index_id,
			:answer => self.answer,
			:content => self.content,
			:description => self.description,
			:form_type => self.form_type,
			:order_level => self.order_level,
			:title => self.title,
		}
		item = Kf::CourseForm.new new_data
		item.image_cover.upload_url = self[:image_cover]
		item.save
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
