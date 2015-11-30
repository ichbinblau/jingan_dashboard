# encoding: utf-8
class Kf::CourseIndex < ActiveRecord::Base
	mount_uploader :image_cover, UserImagesUploader

	belongs_to :kf_course , class_name: "Kf::Course" , foreign_key: "kf_course_id"
	belongs_to :kf_dorctor , class_name: "Kf::Doctor" , foreign_key: "kf_doctor_id"
	belongs_to :kf_course_item_type , class_name: "Kf::CourseItemType" , foreign_key: "kf_course_item_type_id"
	has_many :kf_course_form , class_name: "Kf::CourseForm" , foreign_key: "kf_course_index_id" , :order => "order_level desc"
	accepts_nested_attributes_for :kf_course_form, :allow_destroy => true
	has_many :kf_course_todo , class_name: "Kf::CourseTodo" , foreign_key: "kf_course_index_id" , :order => "order_level desc"
	accepts_nested_attributes_for :kf_course_todo, :allow_destroy => true
	has_many :kf_course_knowledge , class_name: "Kf::CourseKnowledge" , foreign_key: "kf_course_index_id" , :order => "order_level desc"
	accepts_nested_attributes_for :kf_course_knowledge, :allow_destroy => true
	belongs_to :parent, class_name: "Kf::CourseIndex" , foreign_key: "parent_id"
	has_many :course_index_attachment , class_name: "Kf::CourseIndexAttachment" , foreign_key: "kf_course_index_id" , :order => "order_level desc"
	accepts_nested_attributes_for :course_index_attachment, :allow_destroy => true
	attr_accessible :course_index_attachment_attributes , :course_index_attachment_ids 


	attr_accessible :kf_course_form_attributes , :kf_course_form_ids
	attr_accessible :kf_course_todo_attributes , :kf_course_todo_ids
	attr_accessible :kf_course_knowledge_attributes , :kf_course_knowledge_ids
	attr_accessible :image_cover, :image_cover_cache, :remove_image_cover
	attr_accessible :code ,:content, :day_duration, :day_start, :day_start_type,  :kf_course_id, :kf_course_item_type_id \
					, :kf_doctor_id, :order_level, :title ,:item_count , :item_lists , :dc_day_type , :dc_day_offset \
					, :valid_start , :valid_end , :children_count , :parent_id

	def clone_child (offset)
		new_data = get_new_data
		new_data[:children_count] = 0
		new_data[:parent_id] = self.id
		new_data[:day_start] = self.day_start + offset
		item = Kf::CourseIndex.new new_data
		item.save
		return item
	end

	def clone_data( course_id )
		new_data = get_new_data
		new_data[:kf_course_id] = course_id
		item = Kf::CourseIndex.new new_data
		item.image_cover.upload_url = self[:image_cover]
		item.save
		# 复制 kf_course_form
		self.kf_course_form.each do |index|
			index.clone_data(item.id)
		end
		# 复制 kf_course_todo
		self.kf_course_todo.each do |index|
			index.clone_data(item.id)
		end
		# 复制 kf_course_knowledge
		self.kf_course_knowledge.each do |index|
			index.clone_data(item.id)
		end
		# 复制attachment
		self.course_index_attachment.each do |index|
			index.clone_data(item.id)
		end
		# 重新计数
		item = Kf::CourseIndex.find item.id
		item.code = item.code - 1
		item.save

		return item
	end
	def get_new_data
		new_data = {
			:content => self.content,
			:day_duration => self.day_duration,
			:day_start => self.day_start,
			:day_start_type => self.day_start_type,
			:kf_course_id => self.kf_course_id,
			:kf_course_item_type_id => self.kf_course_item_type_id,
			:kf_doctor_id => self.kf_doctor_id,
			:order_level => self.order_level,
			:title => self.title,
			:item_count => self.item_count,
			:item_lists => self.item_lists,
			:dc_day_type => self.dc_day_type,
			:dc_day_offset => self.dc_day_offset,
			:valid_start => self.valid_start,
			:valid_end => self.valid_end,
			:children_count => self.children_count
		}
		return new_data
	end
	
	before_validation :ensure_code
	after_update :ensure_list
	protected
	def ensure_code
		if self.code.nil? || self.code == 0
			self.code = rand(100000000..999999999)
			self.code = rand(1000000000..3999999998) unless Kf::Sort.where(:code => self.code).blank?
		end
	end
	def ensure_list
		unless self.id.blank?
			children = Kf::CourseIndex.where :parent_id => self.id
			children_count = children.size
		end
		item_count = self.kf_course_todo.size + self.kf_course_form.size + self.kf_course_knowledge.size
		# 更新复制的课程title
		if item_count > 0
			children.each do |item|
				item.title = self.title
				item.save
			end
		end
		# 更新item_list字段
		itemlist = []
		self.kf_course_todo.each do |item|
			itemlist.push({
				:id => item[:id],
				:order_level => item[:order_level],
				:title => item[:title],
				:content => item[:content],
			})
		end
		self.kf_course_form.each do |item|
			itemlist.push({
				:id => item[:id],
				:order_level => item[:order_level],
				:image_cover => item[:image_cover],
				:form_type => item[:form_type],
				:title => item[:title],
				:description => item[:description],
				:content => item[:content],
				:answer => item[:answer],
			})
		end
		self.kf_course_knowledge.each do |item|
			itemlist.push({
				:id => item[:id],
				:order_level => item[:order_level],
				:image_cover => item[:image_cover],
				:title => item[:title],
			})
		end
		item_lists = itemlist.to_json
		self.update_column(:item_lists , item_lists)
		self.update_column(:children_count , children_count)
		self.update_column(:item_count , item_count )
	end
end