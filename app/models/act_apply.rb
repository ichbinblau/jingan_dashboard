# encoding: utf-8
class ActApply < ActiveRecord::Base
  # belongs_to :schedule_content,:inverse_of => :cms_info_schedule
  # belongs_to :shop_content,:inverse_of => :cms_info_shop
  # has_one :CmsContent
  # belongs_to :shop_content
  belongs_to :project_info
  attr_accessible  :name,:project_info_id,:int1_des,:int2_des,:int3_des,:int4_des,:int5_des,:text1_des,:text2_des,:text3_des,:text4_des,:text5_des,:text6_des,:text7_des,:text8_des,:text9_des,:text10_des

  has_many :cms_info_applies, :inverse_of => :act_apply
  attr_accessible :act_apply_id

  # belongs_to :statu_content,:inverse_of => :act_statu
  # belongs_to :course_content, :inverse_of => :cms_info_schedules
  # attr_accessible :course_content_id

  rails_admin do
    list do
      field :name
      field :id
      field :project_info_id
    end
    navigation_label '项目'
    weight 12
  end
end
