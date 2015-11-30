# encoding: utf-8
class CmsInfoShopsCmsInfoCoupon < ActiveRecord::Base
  belongs_to :cms_info_shop
  belongs_to :cms_info_coupon
  attr_accessible  :cms_info_shop_id,:cms_info_coupon_id
  rails_admin do
    visible false
  end
end