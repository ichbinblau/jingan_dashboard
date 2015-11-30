# encoding: utf-8
class ProjectCompanie < ActiveRecord::Base
	has_many :project_info
  attr_accessible :project_info_attributes , :project_info_ids
  accepts_nested_attributes_for :project_info, :allow_destroy => true

	attr_accessible :name, :address ,:phone,:description
	rails_admin do
  		navigation_label '项目'
  		weight 1
    end

end
