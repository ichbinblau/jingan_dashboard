# encoding: utf-8
class Admins::SysUserConsigneeController < ApplicationController
  before_filter:authenticate_admin_user!
  def perpage
    20
  end
  def app_module_info
    @admin_info = admin_info
  end
  def index
    app_module_info
    # 内容列表
    params[:per_page] = perpage if params[:per_page].blank?
    params[:page] = 1 if params[:page].blank?
    joins="join `user_infos` on (`user_infos`.id = `user_consignees`.`user_info_id`)"
    search = "`user_infos`.`project_info_id`=#{admin_info.project_info_id} "
    search += " and consignee_name like '%#{params[:words]}%'" if !params[:words].blank?

    @content_items = UserConsignee
                    .joins( joins )
                    .where( search )
                    .order("id DESC").paginate(:page => params[:page], :per_page => params[:per_page])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @coupon_contents }
    end

  end

  def show
    @content_item = UserConsignee.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @coupon_content }
    end
  end

  def new
    app_module_info
    @content_item = UserConsignee.new
    @content_item.project_info_id = admin_info.project_info_id
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @coupon_content }
    end
  end

  def edit
    app_module_info
    @content_item = UserConsignee.find(params[:id])

  end

  def create
    app_module_info
    @content_item = UserConsignee.new(params[:user_consignee])
    respond_to do |format|
      if @content_item.save
        format.html { redirect_to url_for :action =>"index",:sort_id=>params[:sort_id], notice: '添加成功.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    app_module_info
    @content_item = UserConsignee.find(params[:user_consignee][:id])
    respond_to do |format|
      if @content_item.update_attributes(params[:user_consignee])
        format.html { redirect_to url_for :action =>"index" ,:page=>params[:page],:sort_id=>params[:sort_id], notice: '修改成功.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    app_module_info
    @content_item = UserConsignee.find(params[:id])
    @content_item.destroy

    respond_to do |format|
      format.html { redirect_to url_for :action =>"index" ,:page=>params[:page],:sort_id=>params[:sort_id], notice: '删除成功.' }
      format.json { head :no_content }
    end
  end
end
