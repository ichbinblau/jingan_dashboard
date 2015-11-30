# encoding: utf-8
class CmsInfoProduct < ActiveRecord::Base
    belongs_to :product_content,:inverse_of => :cms_info_product
	  attr_accessible  :is_effective,:is_buy,:cms_info_shop_id,:price,:price_old,:discount,:apply_type,:apply_point,
    :apply_money,:apply_start_time,:apply_end_time,:start_time,:end_time,:member_limit ,:order_count,:is_order,:is_pay

    # has_many :cms_contents_sub_cms_sorts,:foreign_key => "cms_content_id",:primary_key => "cms_content_id"
    # has_one :cms_content

    # has_many :cms_contents_cms_sorts ,:foreign_key => "cms_content_id",:primary_key => "cms_content_id"




   #  has_many :cms_info_shops_cms_info_products
  	# has_many :cms_info_shops, :through => :cms_info_shops_cms_info_products

  	# accepts_nested_attributes_for :cms_info_shops, :allow_destroy => true
  	# attr_accessible :cms_info_shops_attributes , :cms_info_shop_ids


    rails_admin do
		# field :cms_info_shop do
	 #      nested_form false
	 #    end
       visible false
    end
end

# cms_info_shops_cms_info_products
# class CmsInfoShopsCmsInfoProduct < ActiveRecord::Base
#     belongs_to :cms_info_product
#   	belongs_to :cms_info_shop
# end
