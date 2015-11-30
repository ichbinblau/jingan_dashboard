# encoding: utf-8
class CouponContentsShopContents < ActiveRecord::Base
  belongs_to :coupon_content
  belongs_to :shop_content
  attr_accessible  :coupon_content_id,:shop_content_id
  rails_admin do
    visible false
  end
end