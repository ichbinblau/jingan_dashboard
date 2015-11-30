class Kf::Diary < ActiveRecord::Base
	mount_uploader :image_cover, UserImagesUploader
	
	belongs_to :user_info
	has_many :diary_attachment , class_name: "Kf::DiaryAttachment" , foreign_key: "kf_diary_id"
	accepts_nested_attributes_for :diary_attachment, :allow_destroy => true
	has_and_belongs_to_many :kf_course_user_fav , class_name: "Kf::CourseUserFav" , foreign_key: "kf_diary_id" \
							, association_foreign_key: "kf_course_user_fav_id"  , join_table: "kf_course_user_favs_kf_diaries"
	accepts_nested_attributes_for :kf_course_user_fav
	attr_accessible :image_cover, :image_cover_cache, :remove_image_cover

	attr_accessible :kf_course_user_fav_attributes , :kf_course_user_fav_ids
	attr_accessible :diary_attachment_attributes , :diary_attachment_ids
	attr_accessible :code , :content, :order_level, :title, :user_info_id, :date
	
	before_validation :ensure_code
	protected
	def ensure_code
		if self.code.nil? || self.code == 0
			self.code = rand(100000000..999999999)
			self.code = rand(1000000000..3999999998) unless Kf::Sort.where(:code => self.code).blank?
		end
	end
end
