# encoding: utf-8
class ActOption < ActiveRecord::Base
  # belongs_to :project_info
  belongs_to :cms_sort_type
  belongs_to :act_apply
  belongs_to :act_option_type
  attr_accessible  :text1,:description,:act_apply_id,:cms_sort_type_id,:act_option_type_id, :type_name, :order_level
  # has_many :cms_info_plans, :inverse_of => :act_statu
  def type_name_enum
    [ [ '数字字段1', 'int1' ] ,[ '数字字段2', 'int2' ] ,[ '数字字段3', 'int3' ] ,[ '数字字段4', 'int4' ],[ '数字字段5', 'int5' ],
      [ '文本字段1', 'text1' ],[ '文本字段2', 'text2' ],[ '文本字段3', 'text3' ],[ '文本字段4', 'text4' ],[ '文本字段5', 'text5' ],
      [ '文本字段6', 'text6' ],[ '文本字段7', 'text7' ],[ '文本字段8', 'text8' ],[ '文本字段9', 'text9' ],[ '文本字段10', 'text10' ]]
  end


  rails_admin do
    configure :type_name ,:enum
    navigation_label '项目'
    weight 12
  end
end
