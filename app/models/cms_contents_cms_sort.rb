class CmsContentsCmsSort < ActiveRecord::Base
  # attr_accessible :title, :body

  attr_accessible :cms_content_id, :cms_sort_id
  belongs_to :cms_sort
  belongs_to :cms_content
  rails_admin do
    visible false
  end
end
