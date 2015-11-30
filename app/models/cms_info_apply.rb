# encoding: utf-8
require "resque"
$:.unshift File.dirname(__FILE__)+'/../lib'
require 'rubygems'
require 'mqtt'
require "iconv"
class CmsInfoApply < ActiveRecord::Base
  validates :act_apply_id,  :presence => { :message => "不能为空" }
  validates :user_info_id,  :presence => { :message => "不能为空" }
  validates :project_info_id,  :presence => { :message => "不能为空" }
  # image_accessor :image_cover



  #attr_accessible :int1,:int2,:int3,:int4,:int5,:text1,:text2,:text3,:text4,:text5,:text6,:text7,:text8,:text9,:text10

  # has_one :cms_info_activity,:dependent => :destroy,:inverse_of => :cms_content
  # has_many :cms_content_img

  #has_one :cms_info_shop , :conditions => ["type=?","NewsContent"]



  #attr_accessible :cms_content_img_attributes , :cms_content_img_ids
  #accepts_nested_attributes_for :cms_content_img, :allow_destroy => true

  #has_many :cms_content_comment, :dependent => :destroy, :inverse_of => :cms_content,:limit =>10




  #accepts_nested_attributes_for :cms_content_comment, :allow_destroy => true
  # attr_accessible :cms_content_comment_attributes, :allow_destroy => true
  # attr_accessible :cms_content_comment_ids

  belongs_to :project_info
  # belongs_to :cms_sort_type
  attr_accessible  :project_info_id,:int1,:int2,:int3,:int4,:int5,:text1,:text2,:text3,:text4,:text5,:text6,:text7,:text8,:text9,:text10,:user_info_id,:act_apply_id,:created_at


  # has_many :cms_info_course, :inverse_of => :cms_content
  # attr_accessible :cms_content_id
  # has_and_belongs_to_many :cms_sorts  # permissions
  #   has_many :cms_content_cms_sort_associations, :dependent => :delete_all, :autosave => true, :include => :cms_sorts
  #   has_many :cms_sorts, :through => :cms_content_cms_sort_associations
  # attr_accessible :cms_sort_ids

  #has_and_belongs_to_many :cms_sorts
  #attr_accessible :cms_sorts_attributes,:cms_sort_ids
  #accepts_nested_attributes_for :cms_sorts, :allow_destroy => true
  #
  #def cms_sorts_options
  #    opts = []
  #    self.cms_sorts.each do |option|
  #      opts << option.id.to_s
  #    end
  #    opts
  #end


  rails_admin do
    visible false
    list do
      field :act_apply_id
      field :user_info_id
      field :project_info_id
    end
  end
end
