# encoding: utf-8
class CmsInfoCoupon < ActiveRecord::Base
    # validates :address,  :presence => { :message => "地址不能为空" }
    belongs_to :coupon_content,:inverse_of => :cms_info_coupon
    belongs_to  :cms_content
    # has_one :cms_info_product ,:foreign_key => "cms_content_id",:primary_key => "cms_content_id"
    # has_many :cms_contents_cms_sorts ,:foreign_key => "cms_content_id",:primary_key => "cms_content_id"


	 
    # belongs_to :cms_info_shop 
    #has_many :cms_info_shops_cms_info_coupons
  	# has_many :cms_info_shops, :through => :cms_info_shops_cms_info_coupons

  	# accepts_nested_attributes_for :cms_info_shops, :allow_destroy => true
  	# attr_accessible :cms_info_shops_attributes , :cms_info_shop_ids
    attr_accessible  :is_effective,:cms_info_shop_id,:price,:price_old,:discount,:apply_type,:apply_point,
    :apply_money,:apply_start_time,:apply_end_time,:start_time,:end_time,:member_limit,:personal_limit,
    :current_count,:address,:longitude,:latitude,:my_all_apply_code

    before_validation :setup_gpsinfo
    # after_validation :setup_afterinfo
    # after_save :setup_after_save
    # after_create :setup_after_save

    protected
    def setup_gpsinfo
      begin
        if self.cms_info_shop_id==nil
          self.cms_info_shop_id = 0
        end
        if self.address!=""
            self.address ||= ""  #{self.address}
            url = URI::encode("http://maps.google.com/maps/geo?q=#{self.address}&output=json&key=ABQIAAAAzr2EBOXUKnm_jVnk0OJI7xSosDVG8KKPE1-m51RBrvYughuyMxQ-i1QfUnH94QxWIa6N4U6MouMmBA")

            info = Net::HTTP.get_response(URI.parse(url)).body
            # Rails.logger.info("eclogger: body------------------------------#{info}") #获取map返回的json字符串
            startindex=info.index("\"coordinates\": [").to_i+17#获取开始的位置
            # Rails.logger.info("eclogger: startindex------------------------------#{startindex}")
            if startindex>17
              endindex=info.length- startindex   #截取最后的位置
              #后面的位置lastIndexOf
              str=info[startindex,endindex]#后面的字符串
              starts=str.index(",")
              strs=info[startindex+starts+2,endindex-starts-2]#后面的字符串
              log=str[0,starts]#经度
              starts2=strs.index(",")
              lat=strs[0,starts2]#经度
              if self.longitude==""
                  self.longitude=log
              end
              if self.latitude==""
                  self.latitude=lat
              end
            end
        end
      rescue Exception => e
      end
    end
      
    # def setup_after_save
    #   cms_info_shop_id = 0
    #   if self.cms_info_shop!=nil
    #         if self.cms_info_shop.id>0
    #             # 添加表关联
    #             cms_info_shop_id=self.cms_info_shop.id 
    #         end
    #         coupon_id = self.id
    #         coupons = CmsInfoShopsCmsInfoCoupon.where("cms_info_coupon_id = ? ",coupon_id.to_s )
    #         if !coupons.blank?
    #             Rails.logger.info("eclogger: id-------------------------"+coupons[0].id.to_s)
    #             cms_info_shops_cms_info_coupon = CmsInfoShopsCmsInfoCoupon.find(coupons[0].id)                    
    #             if !cms_info_shops_cms_info_coupon.blank?
    #                 Rails.logger.info("eclogger: come-------------------------")
    #                 # cis_coupon = CmsInfoShopsCmsInfoCoupon.new()
    #                 cms_info_shops_cms_info_coupon.cms_info_shop_id = cms_info_shop_id
    #                 cms_info_shops_cms_info_coupon.cms_info_coupon_id = coupon_id
    #                 cms_info_shops_cms_info_coupon.save
    #             end
    #         end
    #         if coupons.blank?
    #             cis_coupon = CmsInfoShopsCmsInfoCoupon.new()
    #             cis_coupon.cms_info_shop_id = cms_info_shop_id
    #             cis_coupon.cms_info_coupon_id = coupon_id
    #             cis_coupon.save
    #         end
    #   end
       
    # end

    # def create_contentid
    #   self.save
    # end

    rails_admin do
      include_all_fields
      field :apply_start_time do
        date_format :default
      end
      field :apply_end_time do
        date_format :default
      end
      field :start_time do
        date_format :default
      end
      field :end_time do
        date_format :default
      end
      visible false
    end
end

# 顶佳数码的地址录入是对的，但是地图定位是错误的




# cms_info_shops_cms_info_products
# class CmsInfoShopsCmsInfoCoupon < ActiveRecord::Base
#     belongs_to :cms_info_coupon
#     belongs_to :cms_info_shop
# end
