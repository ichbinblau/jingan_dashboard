# encoding: utf-8
class Kf::Course < ActiveRecord::Base
	mount_uploader :image_cover, UserImagesUploader

	belongs_to :kf_doctor , class_name: "Kf::Doctor" , foreign_key: "kf_doctor_id"
	has_many :kf_course_index , class_name: "Kf::CourseIndex" , foreign_key: "kf_course_id"
	accepts_nested_attributes_for :kf_course_index
	has_and_belongs_to_many :kf_sort , class_name: "Kf::Sort" , foreign_key: "kf_course_id" \
							, association_foreign_key: "kf_sort_id"  , join_table: "kf_courses_kf_sorts"
	accepts_nested_attributes_for :kf_sort

	has_and_belongs_to_many :kf_children , class_name: "Kf::Course" , foreign_key: "kf_course_id" \
							, association_foreign_key: "kf_child_id"  , join_table: "kf_courses_kf_children"
	accepts_nested_attributes_for :kf_children
	attr_accessible :kf_child_attributes , :kf_child_ids


	attr_accessible :kf_sort_attributes , :kf_sort_index_ids
	attr_accessible :kf_course_index_attributes , :kf_course_index_ids
	attr_accessible :code , :content, :day_1_name, :day_2_name, :day_3_name, :day_4_name, :day_5_name, :image_cover \
					, :kf_doctor_id, :order_level, :title ,:fav_count ,:kf_sickness_id,:course_type_id \
					,:day_1_offset, :day_2_offset, :day_3_offset, :day_4_offset, :day_5_offset
	

	def clone_data
		new_data = {
			:content => self.content,
			:day_1_name => self.day_1_name,
			:day_2_name => self.day_2_name,
			:day_3_name => self.day_3_name,
			:day_4_name => self.day_4_name,
			:day_5_name => self.day_5_name,
			:image_cover => self.image_cover.url,
			:kf_doctor_id => self.kf_doctor_id,
			:order_level => self.order_level,
			:title => "（复制）" + self.title,
			:kf_sickness_id => self.kf_sickness_id,
			:course_type_id => self.course_type_id,
			:day_1_offset => self.day_1_offset,
			:day_2_offset => self.day_2_offset,
			:day_3_offset => self.day_3_offset,
			:day_4_offset => self.day_4_offset,
			:day_5_offset => self.day_5_offset
		}
		item = Kf::Course.new new_data
		item.image_cover.upload_url = self[:image_cover]
		item.save
		# 复制indexs
		self.kf_course_index.each do |index|
			if index.parent_id == 0
				new_item = index.clone_data(item.id)
				# 复制带子内容的
				if index.children_count > 0
					children =  Kf::CourseIndex.where(:parent_id => index.id)
					children.each do |child|
						new_data = child.get_new_data
						new_data[:kf_course_id] = new_item.kf_course_id
						new_data[:parent_id] = new_item.id
						new_item = Kf::CourseIndex.new new_data
						new_item.save
					end
				end
			end
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
