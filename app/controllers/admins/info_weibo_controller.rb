# encoding: utf-8
class Admins::InfoWeiboController < ApplicationController
  before_filter:authenticate_admin_user!
  def perpage
    20
  end
  def app_module_info
    @admin_info = admin_info
    # 获取模块信息、分类信息
    @module_info = PlugincfgInfo.select("plugincfg_infos.*,plugincfg_types.name as tname,plugincfg_types.configs as tconfigs").joins(:plugincfg_type).find( params[:module_id] )
    @module_info[:tconfigs] = JSON.parse(@module_info[:tconfigs])
    @module_info[:configs] = JSON.parse(@module_info[:configs])
    # Rails.logger.info @module_info.inspect
  end
  def index
    app_module_info
    # 内容列表
    params[:per_page] = perpage if params[:per_page].nil?
    params[:page] = 1 if params[:page].blank?
    @content_items = CmsContent.select("cms_contents.*,cms_sort_types.cnname as sorttype").joins(" left join cms_contents_cms_sorts on( cms_contents.id=cms_contents_cms_sorts.cms_content_id ) left join cms_sorts on (cms_contents_cms_sorts.cms_sort_id=cms_sorts.id) left join cms_sort_types on (cms_sorts.cms_sort_type_id = cms_sort_types.id) ")
    .where( :project_info_id => admin_info.project_info_id ).order("id DESC").paginate(:page => params[:page], :per_page => params[:per_page])
    @app_num = @admin_info[:project_num]
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  def add_status
    initApp(admin_info[:project_num])
    # Rails.logger.info para
    result = callApi("otherapi/weibo_sina/send" , {:text => params[:words]} ,"1.0")
    respond_to do |format|
      format.json { render json: result }
    end
  end
end
