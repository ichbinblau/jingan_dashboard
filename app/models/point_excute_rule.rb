# encoding: utf-8
class PointExcuteRule < ActiveRecord::Base
  attr_accessible  :cycle,:point_count,:condition
  def cycle_enum
    [ [ '每天', '1' ] ,[ '不限周期', '2' ] ,[ '一次性', '3' ] ]
  end

  rails_admin do
    configure :cycle ,:enum
    navigation_label '项目'
    weight 12
  end
end
