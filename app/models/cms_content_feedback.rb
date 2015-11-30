# encoding: utf-8
require "resque"
$:.unshift File.dirname(__FILE__)+'/../lib'
require 'rubygems'
require 'mqtt'
require "iconv"
class CmsContentFeedback < ActiveRecord::Base
  validates :cms_sort_id,  :presence => { :message => "不能为空" }
  validates :user_info_id,  :presence => { :message => "不能为空" }
  validates :project_info_id,  :presence => { :message => "不能为空" }
  belongs_to :project_info
  belongs_to :cms_sort
  attr_accessible  :project_info_id,:cms_sort_id,:user_info_id,:type_num,:content,:contact_info,:is_comment,:comment_info
  rails_admin do
    list do
      field :cms_sort_id
      field :user_info_id
      field :project_info_id
    end
  end
end
