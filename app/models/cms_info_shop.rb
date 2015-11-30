# encoding: utf-8
class CmsInfoShop < ActiveRecord::Base
  # belongs_to :shop_content,:inverse_of => :cms_info_shop
  # attr_accessible  :shop_num,:phone_num,:address,:longitude,:latitude


  belongs_to :shop_content,:inverse_of => :cms_info_shop
 # has_many : cms_content_images, :class_name => "cms_content_image" , :foreeign_key => "cms_cntent_id"

  #场所图片 1..N



  # has_and_belongs_to_many :cms_sorts
  attr_accessible  :shop_num,:phone_num,:address,:longitude,:latitude,:gps_longitude, :gps_latitude, :baidu_longitude, :baidu_latitude
  attr_accessible   :member_num
  before_validation :setup_gpsinfo


  # after_validation :setup_afterinfo
  protected
    def setup_gpsinfo
      begin
        # http://api.map.baidu.com/geocoder/v2/?ak=您的密钥&callback=renderOption&output=json&address=百度大厦&city=北京市


        if !self.address.blank?
          self.address ||= ""
          city = "上海市"
          # http://api.map.baidu.com/geocoder/v2/?ak=#{CONFIG_WEBAPP['key']['ditu_baidu']}&callback=renderOption&output=json&address=#{self.address}&city=#{self.city}
          url = URI::encode "http://api.map.baidu.com/geocoder/v2/?ak=#{CONFIG_WEBAPP['key']['ditu_baidu']}&output=json&address=#{self.address}&city=#{city}"
          info = JSON.parse( Net::HTTP.get_response(URI.parse(url)).body )

          if self.baidu_longitude==""
            self.baidu_longitude = info["result"]["location"]["lng"].to_f.round(6)
          end
          if self.baidu_latitude==""
            self.baidu_latitude = info["result"]["location"]["lat"].to_f.round(6)
          end

          Rails.logger.info self.baidu_latitude.to_s+" -- "+self.baidu_longitude.to_s
          Rails.logger.info "------------------------------------------------------------------"
        end

        
        # if self.address!=""
        #   self.address ||= ""  #{self.address}
        #   # http://api.map.baidu.com/geocoder/v2/?ak=您的密钥&callback=renderOption&output=json&address=百度大厦&city=北京市
        #   url = URI::encode("http://maps.google.com/maps/geo?q=#{self.address}&output=json&key=ABQIAAAAzr2EBOXUKnm_jVnk0OJI7xSosDVG8KKPE1-m51RBrvYughuyMxQ-i1QfUnH94QxWIa6N4U6MouMmBA")
        #   info = Net::HTTP.get_response(URI.parse(url)).body
        #   Rails.logger.info info
        #   startindex=info.index("\"coordinates\": [").to_i+17#获取开始的位置
        #   # Rails.logger.info("eclogger: startindex------------------------------#{startindex}")
        #   if startindex>17
        #     endindex=info.length- startindex   #截取最后的位置
        #     #后面的位置lastIndexOf
        #     str=info[startindex,endindex]#后面的字符串
        #     starts=str.index(",")
        #     strs=info[startindex+starts+2,endindex-starts-2]#后面的字符串
        #     log=str[0,starts]#经度
        #     starts2=strs.index(",")
        #     lat=strs[0,starts2]#经度
        #     if self.longitude==""
        #       self.longitude=log
        #     end
        #     if self.latitude==""
        #       self.latitude=lat
        #     end

        #     # Rails.logger.info "http://api.map.baidu.com/ag/coord/convert?x=#{self.latitude}&y=#{self.latitude}&from=2&to=4&mode=1"
        #     url = URI::encode("http://api.map.baidu.com/ag/coord/convert?x=#{self.longitude}&y=#{self.latitude}&from=2&to=4&mode=1")
        #     info = JSON.parse( Net::HTTP.get_response(URI.parse(url)).body )
        #     b_lon = Base64.decode64(info.first["x"])
        #     b_lat = Base64.decode64(info.first["y"])
        #     if self.baidu_longitude==""
        #       self.baidu_longitude=b_lon
        #     end
        #     if self.baidu_latitude==""
        #       self.baidu_latitude=b_lat
        #     end
        #     # http://api.map.baidu.com/ag/coord/convert?x=121.49000803964238&y=31.29909141860698&from=2&to=4&mode=1
        #   end
        # end

      rescue Exception => e
        Rails.logger.info e.to_s
      end
    end
    # attr_accessible :cms_sorts_attributes,:cms_sort_ids
    # accepts_nested_attributes_for :cms_sorts, :allow_destroy => true


    # has_many :cms_info_shops_cms_info_products
    # has_many :cms_info_products, :through => :cms_info_shops_cms_info_products

    # has_many :cms_info_shops_cms_info_coupons
    # has_many :cms_info_coupons, :through => :cms_info_shops_cms_info_coupons

    # has_many :cms_info_shops_cms_info_limitcoupons
    # has_many :cms_info_limitcoupons, :through => :cms_info_shops_cms_info_limitcoupons

    #attr_accessible :shop_num
    # has_and_belongs_to_many :cms_info_products
    # attr_accessible  :cms_content_info_id,:is_effective,:cms_info_shop_id,:apply_type,:apply_money,:apply_end_time,:address,:longitude
    rails_admin do
      visible false
    end

end
