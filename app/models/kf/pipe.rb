class Kf::Pipe < ActiveRecord::Base
	mount_uploader :image_cover, UserImagesUploader
	attr_accessible :image_cover, :image_cover_cache, :remove_image_cover

	has_many :children , class_name: "Kf::Pipe" , foreign_key: "father_id" , :order => "order_level desc"
	belongs_to :father, class_name: "Kf::Pipe" , foreign_key: "father_id"
	has_many :posterities , class_name: "Kf::Pipe" , foreign_key: "top_id"
	belongs_to :top, class_name: "Kf::Pipe" , foreign_key: "top_id"
	has_and_belongs_to_many :kf_sorts , class_name: "Kf::Sort" , foreign_key: "kf_pipe_id" \
							, association_foreign_key: "kf_sort_id"  , join_table: "kf_pipes_kf_sorts" \
							, :order => "order_level desc"  do
								def for_deep(deep)
									where(:deep => 3)
								end
							end
	accepts_nested_attributes_for :kf_sorts
	attr_accessible :kf_sort_attributes , :kf_sort_ids

	attr_accessible :code, :count_string1, :count_string2, :deep, :description, :father_id, :image_cover, :order_level, :pipepoint_count, :title, :top_id, :type_id, :user_id

	before_validation :ensure_code
	protected
	def ensure_code
		if self.code.nil? || self.code == 0
			self.code = rand(100000000..999999999)
			self.code = rand(1000000000..3999999998) unless Kf::Sort.where(:code => self.code).blank?
		end
		count = 0
		self.kf_sorts.each do |item|
			count = count + item.pipepoint_count
		end
		self.pipepoint_count = count
	end
end
