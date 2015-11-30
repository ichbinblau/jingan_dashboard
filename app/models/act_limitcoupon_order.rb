# encoding: utf-8
class ActLimitcouponOrder < ActiveRecord::Base
    validates :project_info_id,  :presence => { :message => "项目不能为空" }
    validates :user_info_id,  :presence => { :message => "用户不能为空" }
    validates :act_status_type_id,  :presence => { :message => "订单状态不能为空" }
    validates :cms_content_limitcoupon_id,  :presence => { :message => "优惠不能为空" }
    validates :apply_code,  :presence => { :message => "申请码不能为空" }

  belongs_to :project_info

  attr_accessible  :project_info_id,:user_info_id,:act_status_type_id,:cms_content_limitcoupon_id,:nick_name,:apply_code
  rails_admin do
    navigation_label '用户'
    weight 2
  end
end