# encoding: utf-8
class PointActionType < ActiveRecord::Base
  attr_accessible  :name ,:cnname,:description

  rails_admin do
    object_label_method do
      :cnname_label_method
    end
    navigation_label '项目'
    weight 12
  end
end
