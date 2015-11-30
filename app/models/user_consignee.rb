# encoding: utf-8
require "resque"
$:.unshift File.dirname(__FILE__)+'/../lib'
require 'rubygems'
require 'mqtt'
require "iconv"
class UserConsignee < ActiveRecord::Base
  validates :user_info_id,  :presence => { :message => "不能为空" }
  attr_accessible  :user_info_id,:consignee_name,:consignee_address,:consignee_zip,:phone,:is_default,:id,:remarks
  rails_admin do
    visible false
    list do
      field :user_info_id
    end
  end
end
