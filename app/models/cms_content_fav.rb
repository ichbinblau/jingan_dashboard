class CmsContentFav < ActiveRecord::Base
  attr_accessible :user_info_id , :cms_content_id
  belongs_to :cms_content
  belongs_to :user_info

  rails_admin do
    visible false
  end
end
# .where( cms_sorts: {id: [doctor_sort_id]} ).