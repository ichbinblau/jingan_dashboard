# encoding: utf-8
class NewsContentsShopContents < ActiveRecord::Base
  belongs_to :news_content
  belongs_to :shop_content
  attr_accessible  :news_content_id,:shop_content_id
  rails_admin do
    visible false
  end
end