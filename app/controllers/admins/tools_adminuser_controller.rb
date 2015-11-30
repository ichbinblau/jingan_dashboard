# encoding: utf-8
class Admins::ToolsAdminuserController < ApplicationController
  before_filter:authenticate_admin_user!
  def perpage
    20
  end
  def index
    check_auth
    params[:per_page] = perpage if params[:per_page].blank?
    params[:page] = 1 if params[:page].blank?
    # @admininfo = ProjectCompanie.select("au.email , pi.cnname ,pi.description , pi.project_logo , pc.name , pc.address , pc.phone , pc.description ")
    #                       .joins(" au left join project_infos pi on (au.project_info_id = pi.id) ")
    #                       .joins(" left join project_companies pc on (pi.project_companie_id = pc.id) ")
    @content_items = ProjectCompanie.order("id desc").paginate(:page => params[:page], :per_page => params[:per_page])
    @content_items.all.each do |item|
      # Rails.logger.info item.project_info.admin_user.to_s
    end
  end

  def new
    check_auth
    @content_item = ProjectCompanie.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @coupon_content }
    end
  end

  def edit
    check_auth
    @content_item = ProjectCompanie.find(params[:id])
  end

  def create
    check_auth
    @content_item = ProjectCompanie.new(params[:project_companie])
    respond_to do |format|
      if @content_item.save
        format.html { redirect_to url_for :action =>"index",:sort_id=>params[:sort_id], notice: '添加成功.' }
      else
        format.html { render action: "new" }
        # render json: @content_item.errors
      end
    end
  end

  def update
    check_auth
    @content_item = ProjectCompanie.find(params[:project_companie][:id])
    respond_to do |format|
      if @content_item.update_attributes(params[:project_companie])
        format.html { redirect_to url_for :action =>"index" ,:page=>params[:page],:sort_id=>params[:sort_id], notice: '修改成功.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    check_auth
    @content_item = ProjectCompanie.find(params[:id])
    @content_item.destroy

    respond_to do |format|
      format.html { redirect_to url_for :action =>"index" ,:page=>params[:page],:sort_id=>params[:sort_id], notice: '删除成功.' }
      format.json { head :no_content }
    end
  end

  private
  def check_auth
    @admin_info = AdminUser.select("admin_users.email ,admin_users.project_info_id, project_infos.*")
    .joins(" left join project_infos on( admin_users.project_info_id = project_infos.id)").find(current_admin_user.id)
    return render :text => '权限错误' if @admin_info.project_info_id != -1
    @module_info = PlugincfgInfo.select("plugincfg_infos.*,plugincfg_types.name as tname").joins(:plugincfg_type).find( params[:module_id] )
  end

end
