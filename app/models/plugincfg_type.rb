# encoding: utf-8
class PlugincfgType < ActiveRecord::Base
  belongs_to :plugincfg_sort
  has_many :plugincfg_field
  has_many :plugincfg_info

  attr_accessible :description, :name,:show_name, :plugincfg_sort_id
  rails_admin do
    navigation_label '插件'
    weight 12
  end
end
