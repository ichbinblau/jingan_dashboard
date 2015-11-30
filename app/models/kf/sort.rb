class Kf::Sort < ActiveRecord::Base
	mount_uploader :image_cover, UserImagesUploader

	has_many :children , class_name: "Kf::Sort" , foreign_key: "father_id" , :order => "order_level desc"
	belongs_to :father, class_name: "Kf::Sort" , foreign_key: "father_id"
	has_many :posterities , class_name: "Kf::Sort" , foreign_key: "top_id"
	belongs_to :top, class_name: "Kf::Sort" , foreign_key: "top_id"
	belongs_to :kf_sort_type , class_name: "Kf::SortType" , foreign_key: "type_id"
	has_and_belongs_to_many :kf_course , class_name: "Kf::Course" , foreign_key: "kf_sort_id" \
							, association_foreign_key: "kf_course_id"  , join_table: "kf_courses_kf_sorts" \
							, :order => "order_level desc"
	accepts_nested_attributes_for :kf_course
	attr_accessible :image_cover, :image_cover_cache, :remove_image_cover

	attr_accessible :kf_course_attributes , :kf_course_ids
	attr_accessible :code,:deep, :description, :father_id, :name, :order_level, :top_id, :type_id ,:kf_pipe_id, :pipepoint_count

	before_validation :ensure_code
	protected
	def ensure_code
		if self.code.nil? || self.code == 0
			self.code = rand(100000000..999999999)
			self.code = rand(1000000000..3999999998) unless Kf::Sort.where(:code => self.code).blank?
		end
	end
end
