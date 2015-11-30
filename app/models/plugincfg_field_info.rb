# encoding: utf-8
class PlugincfgFieldInfo < ActiveRecord::Base
  attr_accessible :plugincfg_field_id, :plugincfg_info_id ,:show_name
  belongs_to :plugincfg_field
  belongs_to :plugincfg_info
  rails_admin do
    navigation_label '插件'
    weight 14
    visible false
  end
end
