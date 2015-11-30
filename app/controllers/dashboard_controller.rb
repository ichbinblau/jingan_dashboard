class DashboardController < ApplicationController
  before_filter:authenticate_admin_user!
  def perpage
    20
  end
  def index
    @admininfo = admin_info
    @apps_list = ProjectApp.where(:project_info_id=>@admininfo.project_info_id).all
    @plugin_list = []
    modules = PlugincfgInfo.select("plugincfg_infos.*,plugincfg_types.configs as tconfigs,plugincfg_types.name as tname,plugincfg_types.plugincfg_sort_id as type").joins(:plugincfg_type)
    .where(:project_info_id => @admininfo.project_info_id).all
    if !modules.blank?
      modules.each do |md|
        plugin_info = md
        plugin_info.configs = JSON.parse(md[:configs]) if !plugin_info.configs.blank?
        plugin_info.tconfigs = JSON.parse(md[:tconfigs]) if !plugin_info.tconfigs.blank?
        @plugin_list.push(plugin_info) 
      end
    end
    @plugin_list.sort_by! { |v| v.configs["order"].to_s }
  end

  def fake_login
    # Rails.logger.info admin_info.project_info_id.to_s
    if admin_info(current_admin_user.id).project_info_id < 0
      session[:admin_user_id] = params[:fake_user_id] || current_admin_user.id
    end
    redirect_to "/dashboard/index"
    return
  end

  def search_shop
    @item_list = ShopContent.select("title as label , id").where("title like '%#{params[:term]}%' and project_info_id = '#{admin_info.project_info_id}'") if !params[:term].nil?
    render json: @item_list
  end
  def search_activity
    @item_list = ActivityContent.select("title as label , id").where("title like '%#{params[:term]}%' and project_info_id = '#{admin_info.project_info_id}'") if !params[:term].nil?
    render json: @item_list
  end
  def search_product
    @item_list = ProductContent.select("title as label , id").where("title like '%#{params[:term]}%' and project_info_id = '#{admin_info.project_info_id}'") if !params[:term].nil?
    render json: @item_list
  end
  def sort_list
    list_1 = CmsSort.where(:id =>params[:sort_id] , :project_info_id => admin_info.project_info_id )
    list_2 = list_1.blank? ? [] : CmsSort.where("father_id in (#{list_1.collect{|item| item.id}.join(',')})") 
    list_3 = list_2.blank? ? [] : CmsSort.where("father_id in (#{list_2.collect{|item| item.id}.join(',')})") 
    render json: list_1 + list_2 + list_3
  end
  def sort_edit
    sort = CmsSort.where(:id =>params[:sort_id] , :project_info_id => admin_info.project_info_id ).first
    sort.father_id = Integer(params[:father_id]) if !params[:father_id].blank?
    sort.name = params[:name] if !params[:name].blank?
    sort.cnname = params[:name] if !params[:name].blank?
    sort.sort_order = Integer(params[:sort_order]) if !params[:sort_order].blank?
    sort.save
    # CmsSort.new({:father_id => params[:father_id],:name => params[:name],:cnname => params[:name],:sort_order => params[:sort_order],:project_info_id => admin_info.project_info_id}).save
    render json: {:success => true}
  end
  def sort_add
    CmsSort.new({:father_id => params[:father_id],:name => params[:name],:cnname => params[:name],:sort_order => params[:sort_order],:project_info_id => admin_info.project_info_id}).save
    render json: {:success => true}
  end
  def sort_remove
    CmsSort.where(:id =>params[:sort_id] , :project_info_id => admin_info.project_info_id ).first.destroy
    render json: {:success => true}
  end
end
