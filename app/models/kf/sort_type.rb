class Kf::SortType < ActiveRecord::Base
	mount_uploader :image_cover, UserImagesUploader
	has_many :kf_sort , class_name: "Kf::Sort" , foreign_key: "type_id"
  	attr_accessible :description, :image_cover, :order_level, :title
end
