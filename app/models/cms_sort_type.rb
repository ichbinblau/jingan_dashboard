# encoding: utf-8
class CmsSortType < ActiveRecord::Base
	has_many :cms_sort 
	attr_accessible  :name ,:cnname , :description #, :level , :top_sort_id

    rails_admin do
		visible false
        navigation_label '项目'
        weight 5
        object_label_method do
	      :cnname_label_method
	    end
	    
    end
end

