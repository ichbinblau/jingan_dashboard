# encoding: utf-8
require "resque"
$:.unshift File.dirname(__FILE__)+'/../lib'
require 'rubygems'
require 'mqtt'
require "iconv"
class ActBuyOrder < ActiveRecord::Base
  validates :project_companie_id,  :presence => { :message => "不能为空" }
  validates :project_info_id,  :presence => { :message => "不能为空" }

  has_many :act_buy_people_order
  has_many :cms_content_product_details
  belongs_to :shop_content

  attr_accessible :act_buy_people_order_attributes, :act_buy_people_order_ids
  accepts_nested_attributes_for :act_buy_people_order, :allow_destroy => true

  attr_accessible  :act_buy_people_order,:id,:project_companie_id,:project_info_id,:act_status_type_id,:json_property,:title \
                  ,:order_number,:payment_type,:send_type,:user_consignee_id,:product_price,:fare_price,:must_price,:remarks \
                  ,:created_at,:updated_at,:user_info_id,:username,:phone,:home_num,:card_id,:people_num,:check_time \
                  ,:departure_time,:about_time,:sex,:come_from,:age,:address,:source,:c,:product_num,:shop_content_id

  def load_record_relations(names)
    item = self
    is_all=names.nil? || names.length==0
    item[:cms_content_product_details]= item.cms_content_product_details if is_all || names.include?(:cms_content_product_details)
    item
  end


  rails_admin do
    visible false
    list do
      field :user_info_id
      field :project_info_id
    end
  end
end
