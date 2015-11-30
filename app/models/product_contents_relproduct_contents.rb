# encoding: utf-8
class ProductContentsRelproductContents < ActiveRecord::Base
  belongs_to :product_content
  belongs_to :relproduct_content
  attr_accessible  :product_content_id,:relproduct_content_id
  rails_admin do
    visible false
  end
end