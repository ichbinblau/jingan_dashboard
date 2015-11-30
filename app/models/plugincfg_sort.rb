# encoding: utf-8
class PlugincfgSort < ActiveRecord::Base
  has_one :plugincfg_type
  attr_accessible :description, :name,:show_name
  rails_admin do
    navigation_label '插件'
    weight 11
  end
end
