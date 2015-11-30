# encoding: utf-8
class Admins::InfoWeixinController < ApplicationController
  before_filter:authenticate_admin_user!
  def perpage
    20
  end
  def app_module_info
    @admin_info = admin_info
    # 获取模块信息、分类信息
    @module_info = PlugincfgInfo.select("plugincfg_infos.*,plugincfg_types.name as tname").joins(:plugincfg_type).find( params[:module_id] )
    @module_info[:configs] = JSON.parse(@module_info[:configs]);
  end
  def index
    app_module_info
    @weixin_module_list = [];
    # 获取app 模块的微信设置
    app_module_list = PlugincfgInfo.select("plugincfg_infos.*,plugincfg_types.name as tname,plugincfg_types.configs as tconfigs")\
                          .joins(:plugincfg_type).where(:project_info_id => @admin_info.project_info_id,"plugincfg_types.plugincfg_sort_id"=>1).all
    app_module_list.each do |md|
      module_info = md
      module_info.configs = JSON.parse(md[:configs]);
      module_info.tconfigs = JSON.parse(md[:tconfigs]);
      if module_info.tconfigs["weixin"]
        @weixin_module_list.push(module_info)
      end
    end
    initApp(@admin_info[:project_num])
    @weixin_config = callApi("otherapi/weixin/get_config" , {} ,"1.0")
    Rails.logger.info "weixin:"+@weixin_config.inspect
    Rails.logger.info @module_info.inspect
    Rails.logger.info @weixin_module_list.inspect
    respond_to do |format|
      format.html # index.html.erb
    end
  end
end
