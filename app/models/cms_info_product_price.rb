class CmsInfoProductPrice < ActiveRecord::Base
   attr_accessible :price, :p_0, :p_1, :p_2, :p_3, :p_4, :num,:cms_content_id,:that_date,:level,:week_day,:start_time,:end_time
  rails_admin do
    visible false
  end
end
