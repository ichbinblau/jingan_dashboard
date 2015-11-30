# encoding: utf-8
require 'securerandom'
class ActCouponOrder < ActiveRecord::Base
    validates :project_info_id,  :presence => { :message => "项目不能为空" }
    validates :user_info_id,  :presence => { :message => "用户不能为空" }
    validates :act_status_type_id,  :presence => { :message => "订单状态不能为空" }
    validates :cms_content_coupon_id,  :presence => { :message => "优惠不能为空" }
    validates :apply_code,  :presence => { :message => "申请码不能为空" }

	belongs_to :project_info
  belongs_to :cms_content
  belongs_to :cms_info_coupon

  #before_save :generate_token

  #validates_uniqueness_of :apply_code

  def generate_token
    self.apply_code = "#{SecureRandom.hex(4)}"
    self.act_status_type_id = 2
  end

  def act_status_type_text
     text = "未知"
     dic = {
         "0"=>"已创建",
         #"1"=>"下单?",

         "2"=>"已使用",

         #"3"=>"等待确认收货地址",
         "4"=> "已领取",   #未付款
         #"5"=>"收到" ,
         #"6"=>"已使用"
     }
     if dic.has_key?(self.act_status_type_id.to_s)
       text = dic[self.act_status_type_id.to_s]
     end
     text
  end

  attr_accessible  :project_info_id,:user_info_id,:act_status_type_id,:cms_content_coupon_id,:nick_name,:apply_code
  rails_admin do
    navigation_label '用户'
    weight 2
  end
end
