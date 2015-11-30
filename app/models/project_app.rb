# encoding: utf-8
class ProjectApp < ActiveRecord::Base
	require 'digest/md5'
	include WeixinRailsMiddleware::AutoGenerateWeixinTokenSecretKey
	belongs_to :project_info
	has_many :project_app_upload
	has_many :project_app_state_log
	attr_accessible :project_app_upload_attributes , :project_app_upload_ids
	accepts_nested_attributes_for :project_app_upload, :allow_destroy => true
	attr_accessible :project_app_state_log_attributes , :project_app_state_log_ids
	accepts_nested_attributes_for :project_app_state_log, :allow_destroy => true

	mount_uploader :apn_sandbox_key, FileUploader
	mount_uploader :apn_production_key, FileUploader
	mount_uploader :image_icon, UserImagesUploader
	mount_uploader :image_i1, UserImagesUploader
	mount_uploader :image_i2, UserImagesUploader
	mount_uploader :image_i3, UserImagesUploader
	mount_uploader :image_i4, UserImagesUploader
	mount_uploader :image_i5, UserImagesUploader

	attr_accessible :project_info_id, :name, :cnname, :phonetype, :api_key ,:api_secret ,
	:image_icon, :image_icon_cache, :remove_image_icon,
	:image_i1, :image_i1_cache, :remove_image_i1, 
	:image_i2, :image_i2_cache, :remove_image_i2, 
	:image_i3, :image_i3_cache, :remove_image_i3, 
	:image_i4, :image_i4_cache, :remove_image_i4, 
	:image_i5, :image_i5_cache, :remove_image_i5, 
	:apn_sandbox_key, :apn_sandbox_key_cache, :remove_apn_sandbox_key, 
	:apn_production_key, :apn_production_key_cache, :remove_apn_production_key, 
	:slogan,:description,:newupdate_description,:download_url,:version_num,:weixin_secret_key , :weixin_token ,:app_client_num
	

	def phonetype_enum
		[["android" , "android"],["ios" , "ios"],["winphone" , "winphone"],["webapp" , "webapp"] , ["weixinapp" , "weixinapp"]]
	end
	def app_state_enum
        [[ '洽谈客户', '0' ],  [ '签订合同', '10' ], [ '需求整理', '20' ], [ '内容录入', '30' ], [ '技术开发', '40' ],
         [ '内部测试', '50' ], [ '公开测试', '60' ], [ '交付客户', '70' ], [ '发布推广', '80' ],
          [ '暂停发布', '90' ]]
    end
	before_validation :setup_md5
	protected
    def setup_md5
    	if self.api_key.blank?
    		self.api_key = Digest::MD5.hexdigest(rand(9999999).to_s + DateTime.current.to_s)
    	end
    	if self.api_secret.blank?
    		self.api_secret = Digest::MD5.hexdigest(rand(9999999).to_s + DateTime.current.to_s )
    	end
    end
	rails_admin do
  		navigation_label '项目'
  		weight 1
    end
end
