# encoding: utf-8
class CmsSort < ActiveRecord::Base
  # include TheSortableTree::Scopes
  # acts_as_nested_set :parent_column => :father_id ,:depth_column => :level , :order_column => :sort_order
  validates :project_info_id,  :presence => { :message => "不能为空" }
  # validates :cms_sort_type_id,  :presence => { :message => "不能为空" }
  mount_uploader :sort_img, UserImagesUploader
	belongs_to :project_info 
	belongs_to :cms_sort_type 
	belongs_to :father ,:class_name =>"CmsSort" , :foreign_key =>"father_id"
  # has_and_belongs_to_many :activity_content
  # has_and_belongs_to_many :news_content

  has_and_belongs_to_many :cms_content
  has_and_belongs_to_many :plugincfg_info
	attr_accessible :project_info_id , :father_id  , :cms_sort_type_id ,
			:name ,:cnname ,:sort_img, :sort_img_cache, :remove_sort_img, :description , :level , :top_sort_id ,
      :is_property ,:sort_order ,:lft, :rgt

  before_save :setup_beforeinfo
  before_create :setup_beforeinfo
  def setup_beforeinfo
    self.cnname = self.name if self.cnname.blank? && !self.name.blank?
    self.name = self.cnname if self.name.blank? && !self.cnname.blank?
  end
    rails_admin do

      list do
        field :cnname
        field :project_info
        field :father
        field :type
        field :cms_sort_type_id
        field :top_sort_id
        field :level
        field :content_count
        field :name
        field :description
      end

  		navigation_label '项目'
  		weight 5

      object_label_method do
        :sort_label_method
      end
    end
end


