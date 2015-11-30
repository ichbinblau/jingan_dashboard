# encoding: utf-8
class Admins::SysAppconfigController < ApplicationController
  before_filter:authenticate_admin_user!
  def perpage
    20
  end
  def app_module_info
    @admin_info = admin_info
  end
  def index
    app_module_info
    @content_item = []
    @contents = PlugincfgInfo.where(:project_info_id =>  @admin_info.project_info_id ).includes(:plugincfg_type)
    @contents.each do |item| 
      mconfig = JSON.parse( item.plugincfg_type[:configs] )
      if item.plugincfg_type.plugincfg_sort_id == 1 and mconfig["weixin"]
        item.configs =  JSON.parse(item[:configs])
        @content_item.push item
      end
    end
    @content_item.sort_by! { |v| v.configs["order"].to_i }

  end
  def set_order
    orders = params[:orders].split ","
    orders.each do |order|
      plugin_a = order.split ":"
      plugin = PlugincfgInfo.find(plugin_a[1])
      configs =  JSON.parse(plugin[:configs])
      configs["order"] = plugin_a[0]
      plugin.configs = configs.to_json
      plugin.save
    end
    respond_to do |format|
      format.json { render json: {:success => true} }
    end
  end
  def set_weixin_visible
    pinfo = PlugincfgInfo.find(params[:id])
    configs =  JSON.parse(pinfo[:configs])
    configs["isWeiXin"] = (params[:checked] == "true")
    pinfo.configs = configs.to_json
    pinfo.save
    respond_to do |format|
      format.json { render json: {:success => true} }
    end
  end
end
