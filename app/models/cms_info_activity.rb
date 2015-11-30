# encoding: utf-8
class CmsInfoActivity < ActiveRecord::Base
  # validates :address,  :presence => { :message => "地址不能为空" }
  belongs_to :activity_content,:inverse_of => :cms_info_activity #, :polymorphic => true
  # has_one :activity_content ,:as => :cms_content_info#, :inverse_of => :cms_content_info

  attr_accessible  :cms_content_id,:is_effective,:cms_info_shop_id,:apply_type,:apply_point,
    :apply_money,:apply_start_time,:apply_end_time,:start_time,:end_time,:member_limit,:personal_limit,
    :current_count,:address,:longitude,:latitude



  # has_and_belongs_to_many :cms_info_shops
  # attr_accessible :cms_sorts_attributes,:cms_sort_ids
  # accepts_nested_attributes_for :cms_sorts, :allow_destroy => true


  before_validation :setup_gpsinfo
  # after_validation :setup_afterinfo
  protected
    def setup_gpsinfo
      begin
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

    rails_admin do

      include_all_fields
      visible false
    end

end
