class CmsContentProductDetailsLockcfg < ActiveRecord::Base
 attr_accessible :id, :p_0, :p_1, :p_2, :p_3, :p_4,:date,:end_date,:cms_sort_id,:cms_content_id,:locked ,:order_limit ,:order_now ,:created_source

 has_many :cms_contents_cms_sorts,:foreign_key => "cms_content_id",:primary_key => "cms_content_id"
 has_one :cms_info_product,:foreign_key => "cms_content_id",:primary_key => "cms_content_id"

 belongs_to  :cms_content

  def attr_copy(dic={})
    item = self
    if dic.include?(:cms_info_product_price)
      price_item= dic[:cms_info_product_price]
      WebApiTools::ApiCallHelper.get_locked_keys.each do | key|
        item[key]= price_item[key]
      end
    end
  end
  rails_admin do
    visible false
  end
end
