# encoding: utf-8
class ActivityContentsShopContents < ActiveRecord::Base
  belongs_to :activity_content
  belongs_to :shop_content
  attr_accessible  :activity_content_id,:shop_content_id
  rails_admin do
    visible false
  end
end