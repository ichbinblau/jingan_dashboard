# encoding: utf-8
class UserGroup < ActiveRecord::Base
  mount_uploader :image_cover, UserImagesUploader
  attr_accessible :name , :cnname , :subtitle ,:description , :max_num , :now_num ,:project_info_id \
                  ,:news_num ,:order_level \
                  ,:image_cover, :image_cover_cache, :remove_image_cover
  has_and_belongs_to_many :user_infos
  has_and_belongs_to_many :news_contents
  belongs_to :project_info

end
