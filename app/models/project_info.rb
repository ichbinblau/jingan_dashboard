# encoding: utf-8
class ProjectInfo < ActiveRecord::Base
	belongs_to :project_companie 
	has_many :cms_content
	has_many :project_app
	has_many :admin_user
  has_many :user_group
	has_many :cms_sort
	has_many :act_coupon_order
	has_many :act_limitcoupon_order
  has_many :plugincfg_info
  has_many :form_info
  has_many :form_scheme
	mount_uploader :project_guide, UserImagesUploader
	mount_uploader :project_logo, UserImagesUploader

  attr_accessible :admin_user_attributes , :admin_user_ids
  accepts_nested_attributes_for :admin_user, :allow_destroy => true

  attr_accessible :plugincfg_info_attributes , :plugincfg_info_ids
  accepts_nested_attributes_for :plugincfg_info, :allow_destroy => true

  attr_accessible :project_app_attributes , :project_app_ids
  accepts_nested_attributes_for :project_app, :allow_destroy => true

	attr_accessible :name, :cnname ,:description ,:project_companie_id,:project_logo, :project_logo_cache \
                  , :remove_project_logo,:project_guide, :project_guide_cache, :remove_project_guide \
                  , :father_id ,:channel_id , :app_config

	before_save :setup_projectnum
    protected
    def setup_projectnum
    	if self.project_num == 0 || self.project_num == nil
        	self.project_num = rand(999999999)
    	end
    end

	rails_admin do
	  include_all_fields
	  field :cms_content do
	  	hide
	  end

	  object_label_method do
        :project_label_method
      end

  	  navigation_label '项目'
  	  weight 2
    end

end
