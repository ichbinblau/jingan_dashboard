# encoding: utf-8
class SysPushOrder < ActiveRecord::Base

	attr_accessible  :cms_content_id,:project_info_id,:cms_sort_id,:cms_content_title,:updatetime,:pushtype
  rails_admin do
    navigation_label '用户'
    weight 2
  end
end