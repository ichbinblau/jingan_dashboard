class CmsInfoCustomer < ActiveRecord::Base
	# belongs_to :schedule_content,:inverse_of => :cms_info_schedule
	# belongs_to :shop_content,:inverse_of => :cms_info_shop
	# has_one :CmsContent 
	# belongs_to :shop_content 
    mount_uploader :picture, UserImagesUploader
    belongs_to :customer_content,:inverse_of => :cms_info_customers
    attr_accessible :customer_content_id
	  attr_accessible :user_info_id,:name,:nickname ,:cardnum , :birthday,:sex,:picture,:picture_cache, :remove_picture,:phonenumber,:email,:qq,:detail,:product_num,:product_use

	  # belongs_to :shop_content, :inverse_of => :cms_info_schedules
  	# attr_accessible :shop_content_id
    belongs_to :user_info, :inverse_of => :cms_info_customers
    attr_accessible :user_info_id,:nickname

    has_many :cms_info_plans, :inverse_of => :cms_info_customer
    attr_accessible :cms_info_customer_id

    rails_admin do
		  visible false
    end
end