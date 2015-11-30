# encoding: utf-8
class ActivityContentsNewsContents < ActiveRecord::Base
  belongs_to :news_content
  belongs_to :activity_content
  attr_accessible  :news_content_id,:activity_content_id
  rails_admin do
    visible false
  end
end