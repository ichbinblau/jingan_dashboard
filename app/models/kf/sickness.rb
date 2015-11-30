class Kf::Sickness < ActiveRecord::Base
	has_many :kf_course , class_name: "Kf::Course" , foreign_key: "kf_doctor_id"
	accepts_nested_attributes_for :kf_course

	attr_accessible :kf_course_attributes , :kf_course_ids
	attr_accessible :code ,:description, :kf_sort_id, :name

	before_validation :ensure_code
	protected
	def ensure_code
		if self.code.nil? || self.code == 0
			self.code = rand(100000000..999999999)
			self.code = rand(1000000000..3999999998) unless Kf::Sort.where(:code => self.code).blank?
		end
	end
end
