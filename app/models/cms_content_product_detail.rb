# encoding: utf-8
require "resque"
$:.unshift File.dirname(__FILE__)+'/../lib'
require 'rubygems'
require 'mqtt'
require "iconv"
class CmsContentProductDetail < ActiveRecord::Base
  attr_accessible  :id,:act_buy_order_id,:product_num,:cms_content_id,:project_info_id,:user_info_id,:title,:price
  rails_admin do
    visible false
    list do
      field :user_info_id
      field :project_info_id
    end
  end

  def attr_copy(dic={})

    product_detail_M = self
    if dic.include?(:cms_content)
      content_info=  dic[:cms_content]
      product_detail_M[:cms_content_id]= content_info[:id]
      product_detail_M[:project_info_id]= content_info[:project_info_id]
      product_detail_M[:user_info_id]= content_info[:user_info_id]
      product_detail_M[:order_level]= content_info[:order_level]
      product_detail_M[:title]= content_info[:title]
      product_detail_M[:abstract]= content_info[:abstract]
      product_detail_M[:content]= content_info[:content]
      product_detail_M[:image_cover]= content_info[:image_cover]
      product_detail_M[:vote_all]= content_info[:vote_all]
      product_detail_M[:vote_count]= content_info[:vote_count]
      product_detail_M[:comment_count]= content_info[:comment_count]
      product_detail_M[:mages_count]= content_info[:images_count]
      product_detail_M[:up_count]= content_info[:up_count]
      product_detail_M[:down_count]= content_info[:down_count]
      product_detail_M[:view_count]= content_info[:view_count]
    end

    if( dic.include?(:cms_info_product))
      product_info =dic[:cms_info_product]
      product_detail_M[:is_effective]= product_info[:is_effective]
      product_detail_M[:is_buy]= product_info[:is_buy]
      product_detail_M[:cms_info_shop_id]= product_info[:cms_info_shop_id]
      product_detail_M[:price]= product_info[:price]
      product_detail_M[:price_old]= product_info[:price_old]
      product_detail_M[:discount]= product_info[:discount]
      product_detail_M[:apply_type]= product_info[:apply_type]
      product_detail_M[:apply_point]= product_info[:apply_point]
      product_detail_M[:apply_money]= product_info[:apply_money]
      product_detail_M[:apply_start_time]= product_info[:apply_start_time]
      product_detail_M[:apply_end_time]= product_info[:apply_end_time]
      product_detail_M[:start_time]= product_info[:start_time]
      product_detail_M[:end_time]= product_info[:end_time]
      product_detail_M[:member_limit] = product_info[:member_limit]
    end

    if (dic.include?(:act_buy_order))
      buy_order_M=dic[:act_buy_order]
      product_detail_M[:act_buy_order_id]= buy_order_M[:id]
      product_detail_M[:created_at]= buy_order_M[:created_at]
      #product_detail_M[:product_num]= buy_order_M[:product_num]
    end


    if dic.include?(:cms_info_product_price)
      price_M=dic[:cms_info_product_price]
      product_detail_M[:product_num]= price_M[:num]
      product_detail_M[:p_0]= price_M[:p_0]
      product_detail_M[:p_1]= price_M[:p_1]
      product_detail_M[:p_2]= price_M[:p_2]
      product_detail_M[:p_3]= price_M[:p_3]
      product_detail_M[:p_4]= price_M[:p_4]
    end

    if dic.include?(:cms_content_product_details_lockcfg)
      locked_M =dic[:cms_content_product_details_lockcfg]
      product_detail_M[:cms_content_product_details_lockcfg_id]= locked_M[:id]
    end


    self
  end



end
