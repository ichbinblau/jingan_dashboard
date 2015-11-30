# encoding: utf-8
class CmsContentImg < ActiveRecord::Base
	mount_uploader :image, UserImagesUploader

	belongs_to :cms_content #,:counter_cache => :count_of_cms_contents
	attr_accessible :description,:project_info_id,:image, :image_cache, :remove_image #:cms_content_id,:project_id,  
    rails_admin do
      # visible false
      navigation_label '内容'
      weight 50
      object_label_method do
        :image_label_method
      end
      configure :image, :carrierwave
    end

end

  # `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '编号',
  # `project_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '外键-项目',
  # `cms_content_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '外键-内容',
  # `image` varchar(100) NOT NULL DEFAULT '' COMMENT '图片',
  # `description` varchar(100) NOT NULL DEFAULT '' COMMENT '图片说明',
  # `created_at` datetime NOT NULL DEFAULT '2000-01-01 00:00:00' COMMENT '创建时间',
  # `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
