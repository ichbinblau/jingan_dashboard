# encoding: utf-8
class SysLocationInfo < ActiveRecord::Base
  attr_accessible  :project_info_id , :in_effect ,:code ,:location_type , :name ,:cnname , :group_name ,:order_level
  belongs_to :project_info
  belongs_to :father ,:class_name =>"SysLocationInfo" , :foreign_key =>"father_id"

  has_and_belongs_to_many :cms_content

  rails_admin do
    navigation_label '项目'
  end
end