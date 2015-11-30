# encoding: utf-8
class PlugincfgField < ActiveRecord::Base
  attr_accessible :description, :field_options, :field_type, :show_name, :name, :plugincfg_type_id
  belongs_to :plugincfg_type
  has_many :plugincfg_field_info
  
  rails_admin do
    navigation_label '插件'
    weight 13
  end
end
