# encoding: utf-8
class ActOptionType < ActiveRecord::Base
	# has_many :cms_sort 
	attr_accessible  :name ,:cnname , :description #, :level , :top_sort_id
  rails_admin do
    navigation_label '项目'
    weight 12
  end
end

