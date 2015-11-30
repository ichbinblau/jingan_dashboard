# encoding: utf-8
class PlugincfgInfo < ActiveRecord::Base
  attr_accessible :description, :name,:project_info_id,:show_name, :plugincfg_type_id ,:configs
  has_many :plugincfg_field_info
  belongs_to :plugincfg_type
  belongs_to :project_info
  # 分类
  has_and_belongs_to_many :cms_sorts
  attr_accessible :cms_sorts_attributes,:cms_sort_ids
  accepts_nested_attributes_for :cms_sorts, :allow_destroy => true

  rails_admin do
    navigation_label '插件'
    field :cms_sorts do
      nested_form false
    end
    include_all_fields
    weight 15
  end
end
