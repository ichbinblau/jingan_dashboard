# encoding: utf-8
class ProductContentsShopContents < ActiveRecord::Base
  belongs_to :product_content
  belongs_to :shop_content
  attr_accessible  :product_content_id,:shop_content_id
  rails_admin do
    visible false
  end
end