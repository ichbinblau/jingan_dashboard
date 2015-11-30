# encoding: utf-8
class CmsInfoTeacher < ActiveRecord::Base
	# belongs_to :cms_info_teacher,:inverse_of => :cms_info_teacher
	mount_uploader :picture, UserImagesUploader
	belongs_to :teacher_content,:inverse_of => :cms_info_teacher
	attr_accessible :name,:picture,:picture_cache, :remove_picture,:sex,:nickname,:birthday,:detail


    
    rails_admin do
		visible false
    end
end