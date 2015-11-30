# encoding: utf-8
class CmsInfoNews < ActiveRecord::Base
    belongs_to :new_content,:inverse_of => :cms_info_news #, :polymorphic => true
    # has_one :activity_content ,:as => :cms_content_info#, :inverse_of => :cms_content_info
    
	has_and_belongs_to_many :cms_sorts
	attr_accessible :cms_sorts_attributes,:cms_sort_ids
	accepts_nested_attributes_for :cms_sorts, :allow_destroy => true

    # attr_accessible  :cms_content_info_id,:is_effective,:cms_info_shop_id,:apply_type,:apply_money,:apply_end_time,:address,:longitude
    rails_admin do
       visible false
    end

end
